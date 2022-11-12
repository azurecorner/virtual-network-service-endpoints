using Azure.Storage.Files.Shares;
using Azure.Storage.Files.Shares.Models;
using WebApi.Models;

namespace WebApi.Services;

public class FileStorageService : IFileStorageService
{
    // Get the connection string from app settings
    private readonly string _connectionString;

    private const string ShareName = "blog-file-share";
    private const string FolderName = "CustomLogs";

    public FileStorageService(IConfiguration configuration)
    {
        if (configuration != null) _connectionString = configuration.GetValue<string>("ConnectionString");
#pragma warning disable CS4014
        CreateShareAsync(ShareName, new[] { FolderName });
#pragma warning restore CS4014
    }

    //-------------------------------------------------
    // Create a file share
    //-------------------------------------------------
    private async Task CreateShareAsync(string shareName, IEnumerable<string> directories)
    {
        // Instantiate a ShareClient which will be used to create and manipulate the file share
        ShareClient share = new ShareClient(_connectionString, shareName);

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

    public async Task<FileResponse> CreateFileAsync(string shareName, FileRequest postRequest, string folderName)
    {
        ShareClient share = new(_connectionString, shareName);

        var directory = share.GetDirectoryClient(folderName);
        await using Stream data = postRequest.Image.OpenReadStream();
        var file = directory.GetFileClient(postRequest.Image.FileName);
        // Upload the file async
        await file.CreateAsync(data.Length);
        await file.UploadAsync(data);

        return new FileResponse(file.Uri, $"File {postRequest.Image.FileName} Uploaded Successfully");
    }

    public async Task<List<FileDto>?> ListFilesAsync(string shareName, string folderName)
    {
        // Get the connection string from app settings

        // Instatiate a ShareServiceClient
        ShareServiceClient shareService = new ShareServiceClient(_connectionString);

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

    public async Task<FileDto?> DownloadFileAsync(string shareName, string folderName, string fileName)
    {
        // Get a reference to the file
        ShareClient share = new ShareClient(_connectionString, shareName);
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

    public async Task DeleteFileAsync(string shareName, string folderName, string fileName)
    {
        // Get a reference to the file
        ShareClient share = new ShareClient(_connectionString, shareName);
        ShareDirectoryClient directory = share.GetDirectoryClient(folderName);
        ShareFileClient file = directory.GetFileClient(fileName);

        // delete the file
        await file.DeleteIfExistsAsync();
    }
}