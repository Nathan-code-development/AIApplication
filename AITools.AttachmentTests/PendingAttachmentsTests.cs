using AITools.Services;
using Xunit;

namespace AITools.AttachmentTests;

public class PendingAttachmentsTests
{
    private static AiAttachment Add(PendingAttachments pending, string fileName) =>
        pending.Add(fileName, "text/plain", new byte[] { 1, 2, 3 });

    [Fact]
    public void RemovingEarlierAttachment_ThenItsNeighbour_EmptiesTheQueue()
    {
        // Old behaviour: after removing X, Y's chip still held index 1 while
        // the list held one item, so tapping Y's chip silently did nothing.
        var pending = new PendingAttachments();
        var x = Add(pending, "x.txt");
        var y = Add(pending, "y.txt");

        Assert.True(pending.Remove(x));
        Assert.True(pending.Remove(y));

        Assert.Equal(0, pending.Count);
        Assert.Empty(pending.Snapshot());
    }

    [Fact]
    public void RemovingEarlierAttachment_ThenAddingOne_DoesNotRemoveTheNewAttachment()
    {
        // Old behaviour: X occupied index 0, Y index 1. Removing X left Y at
        // index 0; adding Z gave it index 1, which was still Y's captured index.
        // Tapping Y's chip then removed Z and left Y queued.
        var pending = new PendingAttachments();
        var x = Add(pending, "x.txt");
        var y = Add(pending, "y.txt");

        Assert.True(pending.Remove(x));
        var z = Add(pending, "z.txt");

        Assert.True(pending.Remove(y));
        var remaining = pending.Snapshot();
        Assert.Single(remaining);
        Assert.Same(z, remaining[0]);
        Assert.Equal("z.txt", remaining[0].FileName);
    }

    [Fact]
    public void RemovingMiddleThenLast_LeavesTheFirstOne()
    {
        var pending = new PendingAttachments();
        var p = Add(pending, "p.txt");
        var q = Add(pending, "q.txt");
        var r = Add(pending, "r.txt");

        Assert.True(pending.Remove(q));
        Assert.True(pending.Remove(r));

        var remaining = pending.Snapshot();
        Assert.Single(remaining);
        Assert.Same(p, remaining[0]);
    }

    [Fact]
    public void AttachmentsAreRemovedByIdentity_NotByFileName()
    {
        var pending = new PendingAttachments();
        var first = Add(pending, "same.txt");
        var second = Add(pending, "same.txt");

        Assert.True(pending.Remove(first));

        var remaining = pending.Snapshot();
        Assert.Single(remaining);
        Assert.Same(second, remaining[0]);

        Assert.True(pending.Remove(second));
        Assert.Empty(pending.Snapshot());
    }

    [Fact]
    public void RemovingAnInstanceThatWasNeverAdded_DoesNotChangeTheQueue()
    {
        var pending = new PendingAttachments();
        Add(pending, "real.txt");

        var foreign = new AiAttachment
        {
            FileName = "real.txt",
            MimeType = "text/plain",
            Data = new byte[] { 9 }
        };

        Assert.False(pending.Remove(foreign));
        Assert.Equal(1, pending.Count);
    }

    [Fact]
    public void SnapshotIsIndependentOfLaterRemovals()
    {
        var pending = new PendingAttachments();
        var attachment = Add(pending, "kept.txt");
        var snapshot = pending.Snapshot();

        pending.Clear();

        Assert.Equal(0, pending.Count);
        Assert.Single(snapshot);
        Assert.Same(attachment, snapshot[0]);
    }
}
