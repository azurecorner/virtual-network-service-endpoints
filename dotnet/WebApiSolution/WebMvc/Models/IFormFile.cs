namespace WebMvc.Models;

public interface IFormFileCustom
{
    string ContentType { get; }
    string ContentDisposition { get; }
    IHeaderDictionary Headers { get; }
    long Length { get; }
    string Name { get; }
    string FileName { get; }

    Stream OpenReadStream();

    void CopyTo(Stream target);

    Task CopyToAsync(Stream target, CancellationToken cancellationToken);
}