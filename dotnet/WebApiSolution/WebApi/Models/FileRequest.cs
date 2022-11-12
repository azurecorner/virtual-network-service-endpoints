namespace WebApi.Models;

public class FileRequest
{
 
    public string Description { get; set; }
    public IFormFile Image { get; set; }
}