namespace WebApi.Controllers;

public interface IPostService
{
    Task SavePostImageAsync(PostRequest postRequest);
}