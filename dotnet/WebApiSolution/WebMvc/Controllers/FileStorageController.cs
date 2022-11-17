using Microsoft.AspNetCore.Mvc;
using System.Net;
using WebMvc.Models;

namespace WebMvc.Controllers
{
    //https://brokul.dev/sending-files-and-additional-data-using-httpclient-in-net-core
    public class FileStorageController : Controller
    {
        private HttpClient HttpClient { get; }

        public FileStorageController(IHttpClientFactory httpClientFactory)
        {
            var httpClientInstance = httpClientFactory ??
                                  throw new ArgumentNullException(nameof(httpClientFactory));
            HttpClient = httpClientInstance.CreateClient("APIClient");
        }

        // GET: FileStorageController
        public async Task<IActionResult> Index()
        {
            var response = await HttpClient.GetAsync("api/FileStorage/", HttpCompletionOption.ResponseHeadersRead);

            response.EnsureSuccessStatusCode();

            var result = await response.Content.ReadFromJsonAsync<List<fileModel>>();

            return View(result);
        }

        // GET: FileStorageController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: FileStorageController/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: FileStorageController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(AddImageViewModel addImageViewModel)
        {
            var request = new HttpRequestMessage(
                HttpMethod.Post,
                "api/FileStorage/upload");

            var imageFile = addImageViewModel.Files.First();

            await using Stream stream = imageFile.OpenReadStream();
            var payload = new
            {
                Description = "test description"
            };

            request.Content = new MultipartFormDataContent
            {
                // file
                { new StreamContent(stream), "Image", imageFile.FileName },

                // payload

                { new StringContent(payload.Description), "Description" }
            };
            // use it : https://learn.microsoft.com/en-us/aspnet/web-api/overview/advanced/calling-a-web-api-from-a-net-client
            var response = await HttpClient.SendAsync(request, HttpCompletionOption.ResponseHeadersRead);
            response.EnsureSuccessStatusCode();
            return RedirectToAction(nameof(Index));
        }

        // GET: FileStorageController/Edit/5
        public IActionResult Edit(int id)
        {
            return View();
        }

        // POST: FileStorageController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: FileStorageController/Delete/5
        public IActionResult Delete(int id)
        {
            return View();
        }

        // POST: FileStorageController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        public IFormFile GetFormFile(FileStreamResult fsr)
        {
            using var fs = fsr.FileStream;
            return new FormFile(fs, 0, fs.Length, "name", fsr.FileDownloadName);
        }

        public async Task<IActionResult> Download(string uri)
        {
            uri = WebUtility.UrlEncode(uri);
            var response = await HttpClient.GetAsync($"api/FileStorage/download/{uri}", HttpCompletionOption.ResponseHeadersRead);

            response.EnsureSuccessStatusCode();

            var contentDisposition = response.Content.Headers.ContentDisposition;
            var contentType = response.Content.Headers.ContentType?.MediaType ?? string.Empty;
            var content = await response.Content.ReadAsByteArrayAsync();

            return File(content, contentType, contentDisposition?.FileNameStar);
        }
    }
}