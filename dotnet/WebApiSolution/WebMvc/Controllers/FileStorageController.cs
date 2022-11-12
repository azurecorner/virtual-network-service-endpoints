using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using WebMvc.Models;

namespace WebMvc.Controllers
{
    //https://brokul.dev/sending-files-and-additional-data-using-httpclient-in-net-core
    public class FileStorageController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;

        public FileStorageController(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory ??
                                 throw new ArgumentNullException(nameof(httpClientFactory));
        }

        // GET: FileStorageController
        public async Task<ActionResult> Index()
        {
            var httpClient = _httpClientFactory.CreateClient("APIClient");

            var request = new HttpRequestMessage(
                HttpMethod.Get,
                "/FileStorage/");

            var response = await httpClient.SendAsync(
                request, HttpCompletionOption.ResponseHeadersRead);

            response.EnsureSuccessStatusCode();

            await using var responseStream = await response.Content.ReadAsStreamAsync();
            var images = await JsonSerializer.DeserializeAsync<List<fileModel>>(responseStream);
            return View(images);
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
            var httpClient = _httpClientFactory.CreateClient("APIClient");

            var request = new HttpRequestMessage(
                HttpMethod.Post,
                "/FileStorage/upload");

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

            var response = await httpClient.SendAsync(request, HttpCompletionOption.ResponseHeadersRead);
            response.EnsureSuccessStatusCode();
            return RedirectToAction(nameof(Index));
        }

        // GET: FileStorageController/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: FileStorageController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
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
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: FileStorageController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
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
    }
}