namespace WebApi.Controllers;

public class PostService : IPostService
{
    public async Task SavePostImageAsync(PostRequest postRequest)
    {
        var uniqueFileName = postRequest.Image.FileName;

        var uploads = "dirToUplaod";

        var filePath = Path.Combine(uploads, uniqueFileName);

        Directory.CreateDirectory(Path.GetDirectoryName(filePath) ?? string.Empty);

        await postRequest.Image.CopyToAsync(new FileStream(filePath, FileMode.Create));
    }
}