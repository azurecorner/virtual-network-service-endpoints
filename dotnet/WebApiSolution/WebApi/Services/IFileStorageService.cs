using WebApi.Models;

namespace WebApi.Services;

public interface IFileStorageService
{
    Task<FileResponse> CreateFileAsync(string shareName, FileRequest postRequest, string folderName);

    Task<List<FileDto>?> ListFilesAsync(string shareName, string folderName);

    Task<FileDto?> DownloadFileAsync(string shareName, string folderName, string fileName);

    Task DeleteFileAsync(string shareName, string folderName, string fileName);
}