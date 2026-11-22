namespace AITools.Services;

/// <summary>
/// The attachments queued for the next chat turn.
///
/// Removal is by object identity, not by the position an attachment had when
/// its chip was created. The old code captured <c>_attachments.Count - 1</c>
/// inside each chip's tap handler, so once an earlier chip was removed every
/// later index pointed at the wrong item: the chip could remove a different
/// file, or silently fail to remove its own file while the file was still
/// sent to the model.
/// </summary>
public sealed class PendingAttachments
{
    private readonly List<AiAttachment> _items = new();

    public int Count => _items.Count;

    /// <summary>Adds an attachment and returns the object used as its identity.</summary>
    public AiAttachment Add(string fileName, string mimeType, byte[] data)
    {
        var attachment = new AiAttachment
        {
            FileName = fileName,
            MimeType = mimeType,
            Data = data
        };
        _items.Add(attachment);
        return attachment;
    }

    /// <summary>Removes exactly the attachment instance passed in.</summary>
    public bool Remove(AiAttachment attachment) => _items.Remove(attachment);

    /// <summary>A copy safe to hand to the request builder.</summary>
    public List<AiAttachment> Snapshot() => new(_items);

    public void Clear() => _items.Clear();
}
