using Azure;

namespace WebApi;

public class testing
{
    public async Task run()
    {
        try
        {
            await new FileService().CreateShareAsync("myshare");
            var file = new FileInfo("data/fileToUpload.html");
            await new FileService().CreateFileAsync("myshare", file);
            new FileService().ListSnapshotContents("myshare");
            ////await CreateContainerAndUploadBlobAsync();

            ////await ListContainersWithTheirBlobsAsync();

            ////await DownloadBlobAsync();

            ////Console.WriteLine();
            ////Console.WriteLine($"Press ENTER to delete blob container '{BlobContainerName}'");
            ////Console.ReadLine();

            ////await DeleteContainerAsync();
        }
        catch (RequestFailedException exception)
        {
            Console.WriteLine($"Error: {exception.ErrorCode}");

            if (exception.ErrorCode == "ContainerBeingDeleted")
            {
                //Console.WriteLine($"> The container '{BlobContainerName}' is currently being deleted.");
                Console.WriteLine("> This takes usually up to 30 seconds.");
                Console.WriteLine("> Wait a bit and run the program again.");
            }
        }
        catch (Exception exception)
        {
            Console.WriteLine(exception.Message);
        }
    }
}