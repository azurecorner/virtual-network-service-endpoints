namespace WebApi.Controllers;

public class PostResponse
{
    private readonly Uri _fileUri;
    private readonly string _status;

    public PostResponse(Uri fileUri, string status)
    {
        _fileUri = fileUri;
        _status = status;
    }
}