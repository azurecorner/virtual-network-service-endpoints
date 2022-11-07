using Azure;
using Azure.Storage.Files.Shares;
using Azure.Storage.Files.Shares.Models;

namespace WebApi
{
    internal class FileService
    {
        // Get the connection string from app settings
        private const string ConnectionString = "DefaultEndpointsProtocol=https;AccountName=logcorner07092022;AccountKey=RVk8YFFu+k3K9Zh0kuFi/9RKUBiukKah93AkNNcq6A43R5hEpBz8NAQxQ10wMGg4LCCqt+g1gWP6+ASt2zyV+g==;EndpointSuffix=core.windows.net";

        //-------------------------------------------------
        // Copy file within a directory
        //-------------------------------------------------

        //-------------------------------------------------
        // List the snapshots on a share
        //-------------------------------------------------
        public void ListSnapshotContents(string shareName)
        {
            // Get the connection string from app settings

            // Instatiate a ShareServiceClient
            ShareServiceClient shareService = new ShareServiceClient(ConnectionString);

            // Get a ShareClient
            ShareClient share = shareService.GetShareClient(shareName);

            Console.WriteLine($"Share: {share.Name}");

            // Get as ShareClient that points to a snapshot
            //ShareClient snapshot = share.WithSnapshot(snapshotTime);

            // Get the root directory in the snapshot share
            ShareDirectoryClient rootDir = share.GetRootDirectoryClient();

            // Recursively list the directory tree
            ListDirTree(rootDir);
        }

        //-------------------------------------------------
        // Recursively list a directory tree
        //-------------------------------------------------
        private void ListDirTree(ShareDirectoryClient dir)
        {
            // List the files and directories in the snapshot
            foreach (ShareFileItem item in dir.GetFilesAndDirectories())
            {
                if (item.IsDirectory)
                {
                    Console.WriteLine($"Directory: {item.Name}");
                    //var files = item.
                    ShareDirectoryClient subDir = dir.GetSubdirectoryClient(item.Name);
                    ListDirTree(subDir);
                }
                else
                {
                    Console.WriteLine($"File: {dir.Name}\\{item.Name}");
                }
            }
        }

        public async Task CopyFileAsync(string shareName, string sourceFilePath, string destFilePath)
        {
            // Get the connection string from app settings

            // Get a reference to the file we created previously
            ShareFileClient sourceFile = new ShareFileClient(ConnectionString, shareName, sourceFilePath);

            // Ensure that the source file exists
            if (await sourceFile.ExistsAsync())
            {
                // Get a reference to the destination file
                ShareFileClient destFile = new ShareFileClient(ConnectionString, shareName, destFilePath);

                // Start the copy operation
                await destFile.StartCopyAsync(sourceFile.Uri);

                if (await destFile.ExistsAsync())
                {
                    Console.WriteLine($"{sourceFile.Uri} copied to {destFile.Uri}");
                }
            }
        }

        //-------------------------------------------------
        // Create a file share
        //-------------------------------------------------
        public async Task CreateShareAsync(string shareName)
        {
            // Instantiate a ShareClient which will be used to create and manipulate the file share
            ShareClient share = new ShareClient(ConnectionString, shareName);

            // Create the share if it doesn't already exist
            await share.CreateIfNotExistsAsync();

            // Ensure that the share exists
            if (await share.ExistsAsync())
            {
                Console.WriteLine($"Share created: {share.Name}");

                // Get a reference to the sample directory
                ShareDirectoryClient directory = share.GetDirectoryClient("CustomLogs");

                // Create the directory if it doesn't already exist
                await directory.CreateIfNotExistsAsync();

                // Ensure that the directory exists
                if (await directory.ExistsAsync())
                {
                    // Get a reference to a file object
                    ShareFileClient file = directory.GetFileClient("Log1.txt");

                    // Ensure that the file exists
                    if (await file.ExistsAsync())
                    {
                        Console.WriteLine($"File exists: {file.Name}");

                        // Download the file
                        ShareFileDownloadInfo download = await file.DownloadAsync();

                        // Save the data to a local file, overwrite if the file already exists
                        await using FileStream stream = File.OpenWrite(@"downloadedLog1.txt");
                        await download.Content.CopyToAsync(stream);
                        await stream.FlushAsync();
                        stream.Close();

                        // Display where the file was saved
                        Console.WriteLine($"File downloaded: {stream.Name}");
                    }
                }
            }
            else
            {
                Console.WriteLine($"CreateShareAsync failed");
            }
        }

        public async Task CreateFileAsync(string shareName, FileInfo fileInfo)
        {
            var folderName = "CustomLogs";
            var fileName = "Testfile.html";
            var localFilePath = fileInfo.FullName;

            ShareClient share = new(ConnectionString, shareName);

            var directory = share.GetDirectoryClient(folderName);

            var file = directory.GetFileClient(fileName);
            await using FileStream stream = File.OpenRead(localFilePath);
            await file.CreateAsync(stream.Length);
            await file.UploadRangeAsync(new HttpRange(0, stream.Length), stream);
        }
    }
}