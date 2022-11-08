namespace WebApi.Controllers;

public class PostRequest
{
    public int UserId { get; set; }
    public string Description { get; set; }
    public IFormFile Image { get; set; }
}