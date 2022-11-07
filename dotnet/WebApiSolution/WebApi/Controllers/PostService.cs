using Azure.Storage.Files.Shares;
using Azure.Storage.Files.Shares.Models;

namespace WebApi.Controllers;

public class PostService : IPostService
{
    // Get the connection string from app settings
    private const string ConnectionString = "DefaultEndpointsProtocol=https;AccountName=logcorner07092022;AccountKey=RVk8YFFu+k3K9Zh0kuFi/9RKUBiukKah93AkNNcq6A43R5hEpBz8NAQxQ10wMGg4LCCqt+g1gWP6+ASt2zyV+g==;EndpointSuffix=core.windows.net";

    private const string ShareName = "blog-file-share";
    private const string FolderName = "CustomLogs";

    public PostService()
    {
        CreateShareAsync(ShareName, new[] { FolderName });
    }

    //-------------------------------------------------
    // Create a file share
    //-------------------------------------------------
    private async Task CreateShareAsync(string shareName, IEnumerable<string> directories)
    {
        // Instantiate a ShareClient which will be used to create and manipulate the file share
        ShareClient share = new ShareClient(ConnectionString, shareName);

        // Create the share if it doesn't already exist
        await share.CreateIfNotExistsAsync();

        // Ensure that the share exists
        if (await share.ExistsAsync())
        {
            Console.WriteLine($"Share created: {share.Name}");

            foreach (var item in directories)
            {
                // Get a reference to the sample directory
                ShareDirectoryClient directory = share.GetDirectoryClient(item);

                // Create the directory if it doesn't already exist
                await directory.CreateIfNotExistsAsync();

                // Ensure that the directory exists
                if (await directory.ExistsAsync())
                {
                    Console.WriteLine($"directory created: {item}");
                }
            }
        }
        else
        {
            Console.WriteLine("CreateShareAsync failed");
        }
    }

    public async Task<PostResponse> CreateFileAsync(string shareName, PostRequest postRequest, string folderName)
    {
        ShareClient share = new(ConnectionString, shareName);

        var directory = share.GetDirectoryClient(folderName);
        await using Stream data = postRequest.Image.OpenReadStream();
        var file = directory.GetFileClient(postRequest.Image.FileName);
        // Upload the file async
        await file.CreateAsync(data.Length);
        await file.UploadAsync(data);

        return new PostResponse(file.Uri, $"File {postRequest.Image.FileName} Uploaded Successfully");
    }

    public async Task<List<FileDto>?> ListFilesAsync(string shareName, string folderName)
    {
        // Get the connection string from app settings

        // Instatiate a ShareServiceClient
        ShareServiceClient shareService = new ShareServiceClient(ConnectionString);

        // Get a ShareClient
        ShareClient share = shareService.GetShareClient(shareName);

        Console.WriteLine($"Share: {share.Name}");

        var folder = share.GetDirectoryClient(folderName);

        var files = folder.GetFilesAndDirectories();

        return files.Where(f => !f.IsDirectory).Select(r =>
        new FileDto
        {
            Uri = $"{folder.Uri}/{r.Name}",
            Name = r.Name
        }).ToList();
    }

    public async Task<FileDto?> DownloadAsync(string shareName, string folderName, string fileName)
    {
        // Get a reference to the file
        ShareClient share = new ShareClient(ConnectionString, shareName);
        ShareDirectoryClient directory = share.GetDirectoryClient(folderName);
        ShareFileClient file = directory.GetFileClient(fileName);

        if (await file.ExistsAsync())
        {
            Console.WriteLine($"File exists: {file.Name}");

            // Download the file
            ShareFileDownloadInfo download = await file.DownloadAsync();

            Stream fileContent = await file.OpenReadAsync();

            return new FileDto { Content = fileContent, Name = fileName, ContentType = download.ContentType };
        }

        return null;
    }
}