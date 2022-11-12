using System.ComponentModel.DataAnnotations;

namespace WebMvc.Models;

public class ImageForCreation
{
    [Required]
    [MaxLength(150)]
    public string Title { get; set; }

    [Required]
    public byte[] Bytes { get; set; }

    public ImageForCreation(string title, byte[] bytes)
    {
        Title = title;
        Bytes = bytes;
    }
}

public class FileRequest
{
    public int UserId { get; set; }
    public string Description { get; set; }
    public IFormFile Image { get; set; }
}