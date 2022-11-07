namespace WebApi.Controllers;

public interface IPostService
{
    Task<PostResponse> CreateFileAsync(string shareName, PostRequest postRequest, string folderName);

    Task<List<FileDto>?> ListFilesAsync(string shareName, string folderName);

    Task<FileDto?> DownloadAsync(string shareName, string folderName, string fileName);

    Task DeleteAsync(string shareName, string folderName, string fileName);
}