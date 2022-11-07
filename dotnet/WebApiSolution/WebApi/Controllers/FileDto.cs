namespace WebApi.Controllers;

public class FileDto
{
    public string? Uri { get; set; }
    public string? Name { get; set; }
    public Stream Content { get; set; }
    public string ContentType { get; set; }
}