namespace WebApi.Models;

public class FileRequest
{
    public int UserId { get; set; }
    public string Description { get; set; }
    public IFormFile Image { get; set; }
}