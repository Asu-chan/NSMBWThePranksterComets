using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PranksterToolbox.BonusLevelsEditor
{
    public class BonusLevels
    {
        public List<BonusLevel> bonusLevels = new List<BonusLevel>();

        public BonusLevels() { }

        public bool loadOldFile(string path)
        {
            byte[] file = new byte[0];
            try
            {
                file = File.ReadAllBytes(path);
            }
            catch(Exception e)
            {
                MessageBox.Show("Couldn't load file " + path + "\r\n" + e.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return false;
            }


            uint magic = BitConverter.ToUInt32(file.Take(4).Reverse().ToArray(), 0);
            if(magic != 0x50424C46) // PBLF ("Prankster Bonus Levels File")
            {
                MessageBox.Show("This isn't a valid Prankster Bonus Levels File.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return false;
            }

            uint levelCount = BitConverter.ToUInt32(file.Skip(4).Take(4).Reverse().ToArray(), 0);
            for(int i = 0; i < levelCount; i++)
            {
                BonusLevel bonusLevel = new BonusLevel();

                int block = (i * 24) + 8;

                bonusLevel.authorID = BitConverter.ToUInt32(file.Skip(block).Take(4).Reverse().ToArray(), 0);

                uint authorNameByte = BitConverter.ToUInt32(file.Skip(block+4).Take(4).Reverse().ToArray(), 0);
                uint authorQuoteByte = BitConverter.ToUInt32(file.Skip(block+8).Take(4).Reverse().ToArray(), 0);

                bonusLevel.authorName = "";
                bonusLevel.authorQuote = "";

                while(true)
                {
                    char c = BitConverter.ToChar(file.Skip((int)authorNameByte).Take(2).Reverse().ToArray(), 0);
                    if (c != 0) bonusLevel.authorName += c;
                    else break;

                    authorNameByte += 2;
                }

                while(true)
                {
                    char c = BitConverter.ToChar(file.Skip((int)authorQuoteByte).Take(2).Reverse().ToArray(), 0);
                    if (c != 0) bonusLevel.authorQuote += c;
                    else break;

                    authorQuoteByte += 2;
                }

                bonusLevel.filenameW = file[block+0xC];
                bonusLevel.filenameL = file[block+0xD];
                bonusLevel.displaynameW = file[block+0xE];
                bonusLevel.displaynameL = file[block+0xF];

                bonusLevel.topAuthorColor = BitConverter.ToUInt32(file.Skip(block+0x10).Take(4).Reverse().ToArray(), 0);
                bonusLevel.bottomAuthorColor = BitConverter.ToUInt32(file.Skip(block+0x14).Take(4).Reverse().ToArray(), 0);

                bonusLevels.Add(bonusLevel);
            }

            return true;
        }

        public bool loadFile(string path)
        {
            bonusLevels = new List<BonusLevel>();

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
            if (magic != 0x50424C46) // PBLF
            {
                MessageBox.Show("This isn't a valid Prankster Bonus Levels File.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return false;
            }

            uint levelCount = BitConverter.ToUInt32(file.Skip(4).Take(4).Reverse().ToArray(), 0);
            for (int i = 0; i < levelCount; i++)
            {
                BonusLevel bonusLevel = new BonusLevel();

                int block = (i * 32) + 8;

                bonusLevel.authorID = BitConverter.ToUInt32(file.Skip(block).Take(4).Reverse().ToArray(), 0);

                uint authorNameByte = BitConverter.ToUInt32(file.Skip(block + 4).Take(4).Reverse().ToArray(), 0);
                uint authorQuoteByte = BitConverter.ToUInt32(file.Skip(block + 8).Take(4).Reverse().ToArray(), 0);

                bonusLevel.authorName = "";
                bonusLevel.authorQuote = "";

                while (true)
                {
                    char c = BitConverter.ToChar(file.Skip((int)authorNameByte).Take(2).Reverse().ToArray(), 0);
                    if (c != 0) bonusLevel.authorName += c;
                    else break;

                    authorNameByte += 2;
                }

                while (true)
                {
                    char c = BitConverter.ToChar(file.Skip((int)authorQuoteByte).Take(2).Reverse().ToArray(), 0);
                    if (c != 0) bonusLevel.authorQuote += c;
                    else break;

                    authorQuoteByte += 2;
                }

                bonusLevel.filenameW = file[block + 0xC];
                bonusLevel.filenameL = file[block + 0xD];
                bonusLevel.displaynameW = file[block + 0xE];
                bonusLevel.displaynameL = file[block + 0xF];

                bonusLevel.topAuthorColor = BitConverter.ToUInt32(file.Skip(block + 0x10).Take(4).Reverse().ToArray(), 0);
                bonusLevel.bottomAuthorColor = BitConverter.ToUInt32(file.Skip(block + 0x14).Take(4).Reverse().ToArray(), 0);
                bonusLevel.topLevelColor = BitConverter.ToUInt32(file.Skip(block + 0x18).Take(4).Reverse().ToArray(), 0);
                bonusLevel.bottomLevelColor = BitConverter.ToUInt32(file.Skip(block + 0x1C).Take(4).Reverse().ToArray(), 0);

                bonusLevels.Add(bonusLevel);
            }

            return true;
        }

        public byte[] saveAsBytes()
        {
            List<byte> file = new List<byte>();

            file.Add(0x50);
            file.Add(0x42);
            file.Add(0x4C);
            file.Add(0x46);

            file.Add((byte)((bonusLevels.Count & 0xFF000000) >> 24));
            file.Add((byte)((bonusLevels.Count & 0x00FF0000) >> 16));
            file.Add((byte)((bonusLevels.Count & 0x0000FF00) >> 8));
            file.Add((byte)((bonusLevels.Count & 0x000000FF)));

            for (int i = 0; i < bonusLevels.Count; i++)
            {
                file.Add((byte)((bonusLevels[i].authorID & 0xFF000000) >> 24));
                file.Add((byte)((bonusLevels[i].authorID & 0x00FF0000) >> 16));
                file.Add((byte)((bonusLevels[i].authorID & 0x0000FF00) >> 8));
                file.Add((byte)((bonusLevels[i].authorID & 0x000000FF)));

                file.Add(0);
                file.Add(0);
                file.Add(0);
                file.Add(0);

                file.Add(0);
                file.Add(0);
                file.Add(0);
                file.Add(0);

                file.Add(bonusLevels[i].filenameW);
                file.Add(bonusLevels[i].filenameL);
                file.Add(bonusLevels[i].displaynameW);
                file.Add(bonusLevels[i].displaynameL);

                file.Add((byte)((bonusLevels[i].topAuthorColor & 0xFF000000) >> 24));
                file.Add((byte)((bonusLevels[i].topAuthorColor & 0x00FF0000) >> 16));
                file.Add((byte)((bonusLevels[i].topAuthorColor & 0x0000FF00) >> 8));
                file.Add((byte)((bonusLevels[i].topAuthorColor & 0x000000FF)));

                file.Add((byte)((bonusLevels[i].bottomAuthorColor & 0xFF000000) >> 24));
                file.Add((byte)((bonusLevels[i].bottomAuthorColor & 0x00FF0000) >> 16));
                file.Add((byte)((bonusLevels[i].bottomAuthorColor & 0x0000FF00) >> 8));
                file.Add((byte)((bonusLevels[i].bottomAuthorColor & 0x000000FF)));

                file.Add((byte)((bonusLevels[i].topLevelColor & 0xFF000000) >> 24));
                file.Add((byte)((bonusLevels[i].topLevelColor & 0x00FF0000) >> 16));
                file.Add((byte)((bonusLevels[i].topLevelColor & 0x0000FF00) >> 8));
                file.Add((byte)((bonusLevels[i].topLevelColor & 0x000000FF)));

                file.Add((byte)((bonusLevels[i].bottomLevelColor & 0xFF000000) >> 24));
                file.Add((byte)((bonusLevels[i].bottomLevelColor & 0x00FF0000) >> 16));
                file.Add((byte)((bonusLevels[i].bottomLevelColor & 0x0000FF00) >> 8));
                file.Add((byte)((bonusLevels[i].bottomLevelColor & 0x000000FF)));
            }

            for (int i = 0; i < bonusLevels.Count; i++)
            {
                uint lastByte = (uint)file.Count;

                int idx = (i * 32) + 12;

                file[idx] = (byte)((lastByte & 0xFF000000) >> 24);
                file[idx+1] = (byte)((lastByte & 0x00FF0000) >> 16);
                file[idx+2] = (byte)((lastByte & 0x0000FF00) >> 8);
                file[idx+3] = (byte)((lastByte & 0x000000FF));

                foreach(char c in bonusLevels[i].authorName)
                {
                    file.Add((byte)(c >> 8 & 0xFF));
                    file.Add((byte)(c & 0xFF));
                }
                file.Add(0);
                file.Add(0);

                lastByte = (uint)file.Count;

                idx = (i * 32) + 16;

                file[idx] = (byte)((lastByte & 0xFF000000) >> 24);
                file[idx+1] = (byte)((lastByte & 0x00FF0000) >> 16);
                file[idx+2] = (byte)((lastByte & 0x0000FF00) >> 8);
                file[idx+3] = (byte)((lastByte & 0x000000FF));

                foreach(char c in bonusLevels[i].authorQuote)
                {
                    file.Add((byte)(c >> 8 & 0xFF));
                    file.Add((byte)(c & 0xFF));
                }
                file.Add(0);
                file.Add(0);
            }

            return file.ToArray();
        }
    }

    public class BonusLevel
    {
        public uint authorID = 0;
        public string authorName = "";
        public string authorQuote = "";
        public byte filenameW = 0;
        public byte filenameL = 0;
        public byte displaynameW = 0;
        public byte displaynameL = 0;
        public uint topAuthorColor = 0;
        public uint bottomAuthorColor = 0;
        public uint topLevelColor = 0;
        public uint bottomLevelColor = 0;
    }
}
