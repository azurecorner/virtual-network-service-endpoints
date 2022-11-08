namespace WebApi.Models;

public class FileResponse
{
    private readonly Uri _fileUri;
    private readonly string _status;

    public FileResponse(Uri fileUri, string status)
    {
        _fileUri = fileUri;
        _status = status;
    }
}