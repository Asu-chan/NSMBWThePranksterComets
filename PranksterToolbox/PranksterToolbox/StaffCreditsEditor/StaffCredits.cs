using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PranksterToolbox.StaffCreditsEditor
{
    // Format (hex)
    // 0-3: Header (PSCF for "Prankster Staff Credits File")
    // 4-7: Total frame duration (could be calculated at runtime but don't want to waste loading time for that, used to determine speed)
    // 8-B: Pages count
    // C-X: Pages

    // Pages (hex)
    // 0: number of contents after first title
    // 1: number of contents after second title
    // 2-3: frame duration
    // 4-7: Index to title1
    // 8-B: Index to title2
    // C-F: Index to content1
    // 10-13: Index to content2
    // 14-17: Index to content3
    // 18-1B: Index to content4
    // 1C-1F: Index to content5
    // 20-23: Index to content6
    // Note: if an index is 0, it means that object isn't used


    public class StaffCredits
    {
        public List<StaffCreditsPage> pages = new List<StaffCreditsPage>();

        public bool loadFile(string path)
        {
            pages = new List<StaffCreditsPage>();

            byte[] file = new byte[0];
            try
            {
                file = File.ReadAllBytes(path);
            }
            catch (Exception e)
            {
                MessageBox.Show("Couldn't load file " + path + "\r\n" + e.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return false;
            }


            uint magic = BitConverter.ToUInt32(file.Take(4).Reverse().ToArray(), 0);
            if (magic != 0x50534346) // PSCF
            {
                MessageBox.Show("This isn't a valid Prankster Staff Credits File.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return false;
            }

            uint pagesCount = BitConverter.ToUInt32(file.Skip(8).Take(4).Reverse().ToArray(), 0);
            for(int i = 0; i < pagesCount; i++)
            {
                StaffCreditsPage page = new StaffCreditsPage();
                int idx = 0xC + (i * 0x24);

                byte firstContentCount = file[idx];
                byte secondContentCount = file[idx+1];

                page.frameDuration = BitConverter.ToUInt16(file.Skip(idx+2).Take(2).Reverse().ToArray(), 0);
                if (page.frameDuration < 1) page.frameDuration = 1;

                int contentsCount = 0;
                if(firstContentCount > 0)
                {
                    page.title1 = readWideCharAt(ref file, idx + 4);
                    for (contentsCount += 0; contentsCount < firstContentCount; contentsCount++)
                    {
                        page.contents1.Add(readWideCharAt(ref file, idx + 0xC + (contentsCount * 4)));
                    }
                }

                int page1ccount = contentsCount;
                if (secondContentCount > 0)
                {
                    page.title2 = readWideCharAt(ref file, idx + 8);
                    for (contentsCount += 0; contentsCount - page1ccount < secondContentCount; contentsCount++)
                    {
                        page.contents2.Add(readWideCharAt(ref file, idx + 0xC + (contentsCount * 4)));
                    }
                }


                this.pages.Add(page);
            }

            return true;
        }

        public byte[] saveAsBytes()
        {
            List<byte> file = new List<byte>();

            file.AddU32(0x50534346);

            uint totalFrames = 0;
            foreach (StaffCreditsPage page in pages) totalFrames += page.frameDuration;
            file.AddU32(totalFrames);

            file.AddU32((uint)pages.Count);

            foreach (StaffCreditsPage page in pages)
            {
                file.Add((byte)page.contents1.Count);
                file.Add((byte)page.contents2.Count);
                file.AddU16(page.frameDuration);

                for (int i = 0; i < 8; i++) file.AddU32(0); // Space for indexes
            }

            for(int i = 0; i < pages.Count; i++)
            {
                StaffCreditsPage page = pages[i];
                int idx = 0xC + (i * 0x24);

                int contentsCount = 0;
                if (page.title1 != "")
                {
                    file.WriteU32At((uint)file.Count, idx + 4);
                    file.AddStringAsWChar(page.title1);

                    for(contentsCount+=0; contentsCount < page.contents1.Count; contentsCount++)
                    {
                        file.WriteU32At((uint)file.Count, idx + 0xC + (contentsCount * 4));
                        file.AddStringAsWChar(page.contents1[contentsCount]);
                    }
                }

                int page1ccount = contentsCount;
                if (page.title2 != "")
                {
                    file.WriteU32At((uint)file.Count, idx + 8);
                    file.AddStringAsWChar(page.title2);

                    for(contentsCount+=0; contentsCount - page1ccount < page.contents2.Count; contentsCount++)
                    {
                        file.WriteU32At((uint)file.Count, idx + 0xC + (contentsCount * 4));
                        file.AddStringAsWChar(page.contents2[contentsCount - page1ccount]);
                    }
                }
            }

            return file.ToArray();
        }

        

        public string readWideCharAt(ref byte[] file, int idx)
        {
            uint index = BitConverter.ToUInt32(file.Skip(idx).Take(4).Reverse().ToArray(), 0);
            string result = "";
            while (true)
            {
                char c = BitConverter.ToChar(file.Skip((int)index).Take(2).Reverse().ToArray(), 0);
                if (c != 0) result += c;
                else break;

                index += 2;
            }

            return result;
        }
    }

    public class StaffCreditsPage
    {
        public ushort frameDuration = 1;
        public string title1 = "";
        public List<string> contents1 = new List<string>();
        public string title2 = "";
        public List<string> contents2 = new List<string>();
    }

    public static class ByteListExtensions
    {
        public static void AddU32(this List<byte> buffer, uint val)
        {
            buffer?.Add((byte)((val & 0xFF000000) >> 24));
            buffer?.Add((byte)((val & 0x00FF0000) >> 16));
            buffer?.Add((byte)((val & 0x0000FF00) >> 8));
            buffer?.Add((byte)((val & 0x000000FF)));
        }

        public static void WriteU32At(this List<byte> buffer, uint val, int idx)
        {
            buffer[idx]   = (byte)((val & 0xFF000000) >> 24);
            buffer[idx+1] = (byte)((val & 0x00FF0000) >> 16);
            buffer[idx+2] = (byte)((val & 0x0000FF00) >> 8);
            buffer[idx+3] = (byte)((val & 0x000000FF));
        }

        public static void AddU16(this List<byte> buffer, ushort val)
        {
            buffer?.Add((byte)((val & 0xFF00) >> 8));
            buffer?.Add((byte)((val & 0x00FF)));
        }

        public static void AddStringAsWChar(this List<byte> buffer, string str)
        {
            foreach (char c in str)
            {
                buffer?.Add((byte)(c >> 8 & 0xFF));
                buffer?.Add((byte)(c & 0xFF));
            }
            buffer?.AddU16(0);

        }
    }
}
