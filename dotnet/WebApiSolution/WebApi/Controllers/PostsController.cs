using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Mvc;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PostsController : ControllerBase
    {
        private const string ConnectionString = "DefaultEndpointsProtocol=https;AccountName=logcorner07092022;AccountKey=RVk8YFFu+k3K9Zh0kuFi/9RKUBiukKah93AkNNcq6A43R5hEpBz8NAQxQ10wMGg4LCCqt+g1gWP6+ASt2zyV+g==;EndpointSuffix=core.windows.net";

        private const string ShareName = "blog-file-share";
        private const string FolderName = "CustomLogs";

        // READ THIS ==>  https://codingsonata.com/file-upload-with-data-using-asp-net-core-web-api/

        private readonly IPostService _postService;

        public PostsController(IPostService postService)
        {
            _postService = postService;
        }

        [HttpGet(nameof(Get))]
        public async Task<IActionResult> Get()
        {
            // Get all files at the Azure Storage Location and return them
            List<FileDto>? files = await _postService.ListFilesAsync(ShareName,  FolderName);

            // Returns an empty array if no files are present at the storage container
            return StatusCode(StatusCodes.Status200OK, files);
        }

        [HttpPost]
        [Route("")]
        [RequestSizeLimit(5 * 1024 * 1024)]
        public async Task<IActionResult> SubmitPost([FromForm] PostRequest postRequest)
        {
            if (string.IsNullOrEmpty(Request.GetMultipartBoundary()))
            {
                return BadRequest("Invalid post header");
            }

            var response = await _postService.CreateFileAsync(ShareName, postRequest, FolderName);

            return Ok(response);
        }


        [HttpGet("download/{filename}")]
        public async Task<IActionResult> Download(string filename)
        {
            FileDto? file = await _postService.DownloadAsync(ShareName,  FolderName, filename);

            // Check if file was found
            if (file == null)
            {
                // Was not, return error message to client
                return StatusCode(StatusCodes.Status500InternalServerError, $"File {filename} could not be downloaded.");
            }

            // File was found, return it to client
            return File(file.Content, file.ContentType, file.Name);
        }
    }
}