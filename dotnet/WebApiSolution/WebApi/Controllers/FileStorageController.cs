using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Mvc;
using WebApi.Models;
using WebApi.Services;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class FileStorageController : ControllerBase
    {
        private const string ShareName = "blog-file-share";
        private const string FolderName = "CustomLogs";

        // READ THIS ==>  https://codingsonata.com/file-upload-with-data-using-asp-net-core-web-api/
        //https://blog.christian-schou.dk/how-to-use-azure-blob-storage-with-asp-net-core/

        private readonly IFileStorageService _postService;

        public FileStorageController(IFileStorageService postService)
        {
            _postService = postService;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            // Get all files at the Azure Storage Location and return them
            List<FileDto>? files = await _postService.ListFilesAsync(ShareName, FolderName);

            // Returns an empty array if no files are present at the storage container
            return StatusCode(StatusCodes.Status200OK, files);
        }

        [HttpPost]
        [Route("upload")]
        //[RequestSizeLimit(5 * 1024 * 1024)]
        public async Task<IActionResult> SubmitPost([FromForm] FileRequest postRequest)
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
            FileDto? file = await _postService.DownloadFileAsync(ShareName, FolderName, filename);

            // Check if file was found
            if (file == null)
            {
                // Was not, return error message to client
                return StatusCode(StatusCodes.Status500InternalServerError, $"File {filename} could not be downloaded.");
            }

            // File was found, return it to client
            return File(file.Content, file.ContentType, file.Name);
        }

        [HttpDelete("delete/{filename}")]
        public async Task<IActionResult> Delete(string filename)
        {
            await _postService.DeleteFileAsync(ShareName, FolderName, filename);

            // File has been successfully deleted
            return Ok();
        }
    }
}