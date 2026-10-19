# Convert LEXiTRON XML (etlex / telex) into a StarDict dictionary.
# usage: lexitron2stardict.py <etlex|telex> <input.xml> <outdir> <bookname>
import struct
import sys
import xml.etree.ElementTree as ET
from collections import OrderedDict
from pathlib import Path

kind, src, outdir, bookname = sys.argv[1:5]


def text(doc, tag):
    el = doc.find(tag)
    return el.text.strip() if el is not None and el.text and el.text.strip() else None


def render_etlex(doc):
    lines = [f"[{text(doc, 'ecat') or '?'}] {text(doc, 'tentry') or ''}"]
    for tag, label in (("ethai", "="), ("esyn", "syn:"), ("eant", "ant:")):
        if v := text(doc, tag):
            lines.append(f"    {label} {v}")
    return text(doc, "esearch"), lines


def render_telex(doc):
    head = text(doc, "eentry") or ""
    if extra := text(doc, "tenglish"):
        head = f"{head}; {extra}"
    lines = [f"[{text(doc, 'tcat') or '?'}] {head}"]
    for tag, label in (
        ("tdef", "def:"),
        ("tsample", "ex:"),
        ("tsyn", "syn:"),
        ("tant", "ant:"),
        ("notes", "note:"),
    ):
        if v := text(doc, tag):
            lines.append(f"    {label} {v}")
    return text(doc, "tsearch"), lines


render = {"etlex": render_etlex, "telex": render_telex}[kind]

# merge every sense of the same headword into one article
entries = OrderedDict()
for doc in ET.parse(src).getroot().iter("Doc"):
    word, lines = render(doc)
    if word:
        entries.setdefault(word, []).append("\n".join(lines))

# StarDict sorts with g_ascii_strcasecmp, ties broken by strcmp
words = sorted(entries, key=lambda w: (w.encode().lower(), w.encode()))

out = Path(outdir)
out.mkdir(parents=True, exist_ok=True)
idx = bytearray()
with open(out / f"{kind}.dict", "wb") as d:
    offset = 0
    for w in words:
        body = "\n".join(entries[w]).encode()
        d.write(body)
        idx += w.encode() + b"\0" + struct.pack(">II", offset, len(body))
        offset += len(body)
(out / f"{kind}.idx").write_bytes(idx)
(out / f"{kind}.ifo").write_text(
    "StarDict's dict ifo file\n"
    "version=2.4.2\n"
    f"wordcount={len(words)}\n"
    f"idxfilesize={len(idx)}\n"
    f"bookname={bookname}\n"
    "author=NECTEC\n"
    "sametypesequence=m\n"
)
