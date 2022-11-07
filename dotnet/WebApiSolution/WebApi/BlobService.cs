using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

namespace WebApi;

public class BlobService
{
    // TODO: Add your connection string here
    private const string ConnectionString = "DefaultEndpointsProtocol=https;AccountName=logcorner07092022;AccountKey=RVk8YFFu+k3K9Zh0kuFi/9RKUBiukKah93AkNNcq6A43R5hEpBz8NAQxQ10wMGg4LCCqt+g1gWP6+ASt2zyV+g==;EndpointSuffix=core.windows.net";

    private static readonly string BlobContainerName = "authors";
    private static readonly string BlobName = "thomas.html";

    public static async Task CreateContainerAndUploadBlobAsync()
    {
        // 1. Create the Blob Container
        BlobServiceClient blobServiceClient = new BlobServiceClient(ConnectionString);

        BlobContainerClient blobContainerClient =
            blobServiceClient.GetBlobContainerClient(BlobContainerName);

        Console.WriteLine($"1. Creating blob container '{BlobContainerName}'");

        await blobContainerClient.CreateIfNotExistsAsync(PublicAccessType.BlobContainer);

        // 2. Upload a Blob
        BlobClient blobClient = blobContainerClient.GetBlobClient(BlobName);

        Console.WriteLine($"2. Uploading blob '{blobClient.Name}'");
        Console.WriteLine($"   > {blobClient.Uri}");

        await using FileStream fileStream = File.OpenRead("fileToUpload.html");

        await blobClient.UploadAsync(fileStream,
            new BlobHttpHeaders { ContentType = "text/html" });
    }

    public static async Task ListContainersWithTheirBlobsAsync()
    {
        BlobServiceClient blobServiceClient = new BlobServiceClient(ConnectionString);

        Console.WriteLine("3. Listing containers and blobs "
                          + $"of '{blobServiceClient.AccountName}' account");

        await foreach (BlobContainerItem blobContainerItem
                       in blobServiceClient.GetBlobContainersAsync())
        {
            Console.WriteLine($"   > {blobContainerItem.Name}");

            BlobContainerClient blobContainerClient =
                blobServiceClient.GetBlobContainerClient(blobContainerItem.Name);

            await foreach (BlobItem blobItem in blobContainerClient.GetBlobsAsync())
            {
                Console.WriteLine($"     - {blobItem.Name}");
            }
        }
    }

    public static async Task DownloadBlobAsync()
    {
        string localFileName = "downloaded.html";

        Console.WriteLine($"4. Downloading blob '{BlobName}' to local file '{localFileName}'");

        BlobClient blobClient = new BlobClient(ConnectionString, BlobContainerName, BlobName);
        bool exists = await blobClient.ExistsAsync();
        if (exists)
        {
            BlobDownloadInfo blobDownloadInfo = await blobClient.DownloadAsync();

            await using FileStream fileStream = File.OpenWrite(localFileName);
            await blobDownloadInfo.Content.CopyToAsync(fileStream);
        }
    }

    public static async Task DeleteContainerAsync()
    {
        Console.WriteLine($"5. Deleting blob container '{BlobContainerName}'");

        BlobContainerClient blobContainerClient =
            new BlobContainerClient(ConnectionString, BlobContainerName);

        await blobContainerClient.DeleteIfExistsAsync();
    }
}