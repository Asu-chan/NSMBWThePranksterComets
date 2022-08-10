using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PranksterToolbox.OpeningEditor
{
    public partial class Main : Form
    {
        public Main()
        {
            InitializeComponent();
        }

        List<string> texts = new List<string>();
        List<ushort> musics = new List<ushort>();
        List<ushort> sfx = new List<ushort>();
        string path = "";

        private void pageListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            pageTextRichTextBox.Text = texts[pageListBox.SelectedIndex];
            musicNUD.Value = musics[pageListBox.SelectedIndex];
            sfxNUD.Value = sfx[pageListBox.SelectedIndex];
        }

        private void addPageButton_Click(object sender, EventArgs e)
        {
            texts.Add("");
            musics.Add(0);
            sfx.Add(0);
            refreshListBox(texts.Count);
            pageTextRichTextBox.Enabled = true;
            saveAsToolStripMenuItem.Enabled = true;
            if(path != "")
            {
                saveToolStripMenuItem.Enabled = true;
            }
        }

        private void removePageButton_Click(object sender, EventArgs e)
        {
            texts.RemoveAt(pageListBox.SelectedIndex);
            musics.RemoveAt(pageListBox.SelectedIndex);
            sfx.RemoveAt(pageListBox.SelectedIndex);
            refreshListBox(pageListBox.SelectedIndex);
            if (texts.Count == 0)
            {
                pageTextRichTextBox.Enabled = false;
                saveToolStripMenuItem.Enabled = false;
                saveToolStripMenuItem.Enabled = false;
            }
        }

        public void refreshListBox(int sel)
        {
            if(sel == 0) sel++;

            pageListBox.Items.Clear();
            for(int i = 0; i < texts.Count; i++)
            {
                pageListBox.Items.Add("Page " + i);
            }
            pageListBox.SelectedIndex = sel-1;
        }

        private void pageTextRichTextBox_TextChanged(object sender, EventArgs e)
        {
            texts[pageListBox.SelectedIndex] = pageTextRichTextBox.Text;
        }

        private void musicNUD_ValueChanged(object sender, EventArgs e)
        {
            musics[pageListBox.SelectedIndex] = (ushort)musicNUD.Value;
        }

        private void sfxNUD_ValueChanged(object sender, EventArgs e)
        {
            sfx[pageListBox.SelectedIndex] = (ushort)sfxNUD.Value;
        }

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog dialog = new OpenFileDialog())
            {
                string output;
                dialog.Filter = "Prankster Opening File|*.bin|All files (*.*)|*.*";
                dialog.FilterIndex = 1;
                dialog.RestoreDirectory = true;
                if (dialog.ShowDialog() == DialogResult.OK)
                {
                    texts = new List<string>();
                    musics = new List<ushort>();
                    sfx = new List<ushort>();
                    output = dialog.FileName;
                    loadFile(File.ReadAllBytes(output));
                    refreshListBox(1);
                    pageTextRichTextBox.Enabled = true;
                    path = output;
                    this.Text = "Prankster Opening Editor - " + Path.GetFileName(output);

                    saveToolStripMenuItem.Enabled = true;
                    saveAsToolStripMenuItem.Enabled = true;
                }
            }
        }

        private void openOldToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog dialog = new OpenFileDialog())
            {
                string output;
                dialog.Filter = "Prankster Opening File|*.bin|All files (*.*)|*.*";
                dialog.FilterIndex = 1;
                dialog.RestoreDirectory = true;
                if (dialog.ShowDialog() == DialogResult.OK)
                {
                    texts = new List<string>();
                    musics = new List<ushort>();
                    sfx = new List<ushort>();
                    output = dialog.FileName;
                    loadOldFile(File.ReadAllBytes(output));
                    refreshListBox(1);
                    pageTextRichTextBox.Enabled = true;
                    path = output;
                    this.Text = "Prankster Opening Editor - " + Path.GetFileName(output);

                    saveToolStripMenuItem.Enabled = true;
                    saveAsToolStripMenuItem.Enabled = true;
                }
            }
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            File.WriteAllBytes(path, saveFile());
        }

        private void saveAsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveFileDialog textDialog;
            textDialog = new SaveFileDialog();
            textDialog.Filter = "Prankster Opening File|*.bin|All files (*.*)|*.*";
            textDialog.DefaultExt = "bin";
            if (textDialog.ShowDialog() == DialogResult.OK)
            {
                //Stream things to get the saved path
                System.IO.Stream fileStream = textDialog.OpenFile();
                System.IO.StreamWriter sw = new System.IO.StreamWriter(fileStream);
                string outputPath = ((FileStream)(sw.BaseStream)).Name;
                sw.Close();
                path = outputPath;
                this.Text = "Prankster Opening Editor - " + Path.GetFileName(outputPath);

                //Save it
                saveToolStripMenuItem_Click(sender, e);
            }
        }

        public void loadOldFile(byte[] file)
        {
            uint pageCount = BitConverter.ToUInt32(file.Take(4).Reverse().ToArray(), 0);
            for (int i = 0; i < pageCount; i++)
            {
                string txt = "";
                uint index = BitConverter.ToUInt32(file.Skip((i + 1) * 12).Take(4).Reverse().ToArray(), 0);

                while(true)
                {
                    char chr = (char)((file[index] << 8) | file[index+1]);
                    if (chr == 0)
                    {
                        break;
                    }

                    txt += chr;
                    index += 2;
                }

                texts.Add(txt);
                musics.Add(0);
                sfx.Add(0);
            }
        }

        public void loadFile(byte[] file)
        {
            uint pageCount = BitConverter.ToUInt32(file.Take(4).Reverse().ToArray(), 0);
            for (int i = 0; i < pageCount; i++)
            {
                string txt = "";
                uint index = BitConverter.ToUInt32(file.Skip((i + 1) * 16).Take(4).Reverse().ToArray(), 0);

                while(true)
                {
                    char chr = (char)((file[index] << 8) | file[index+1]);
                    if (chr == 0)
                    {
                        break;
                    }

                    txt += chr;
                    index += 2;
                }

                texts.Add(txt);

                musics.Add(BitConverter.ToUInt16(file.Skip((i + 1) * 16 - 4).Take(2).Reverse().ToArray(), 0));
                sfx.Add(BitConverter.ToUInt16(file.Skip((i + 1) * 16 - 2).Take(2).Reverse().ToArray(), 0));
            }
        }

        public byte[] saveFile()
        {
            List<byte> output = new List<byte>();

            output.Add((byte)((texts.Count & 0xFF000000) >> 24));
            output.Add((byte)((texts.Count & 0x00FF0000) >> 16));
            output.Add((byte)((texts.Count & 0x0000FF00) >> 8));
            output.Add((byte)((texts.Count & 0x000000FF)));

            for (int i = 0; i < texts.Count; i++)
            {
                string txt = texts[i].Replace("\r\n", "\n");
                int lineCount = txt.Count(s => s == '\n') + 1;
                output.Add((byte)((lineCount & 0xFF000000) >> 24));
                output.Add((byte)((lineCount & 0x00FF0000) >> 16));
                output.Add((byte)((lineCount & 0x0000FF00) >> 8));
                output.Add((byte)((lineCount & 0x000000FF)));

                int chrCount = txt.Length;
                output.Add((byte)((chrCount & 0xFF000000) >> 24));
                output.Add((byte)((chrCount & 0x00FF0000) >> 16));
                output.Add((byte)((chrCount & 0x0000FF00) >> 8));
                output.Add((byte)((chrCount & 0x000000FF)));

                output.Add((byte)((musics[i] & 0x0000FF00) >> 8));
                output.Add((byte)((musics[i] & 0x000000FF)));
                output.Add((byte)((sfx[i] & 0x0000FF00) >> 8));
                output.Add((byte)((sfx[i] & 0x000000FF)));

                output.Add(0); // Placeholder
                output.Add(0);
                output.Add(0);
                output.Add(0);
            }

            for (int i = 0; i < texts.Count; i++)
            {
                int num = (i + 1) * 16;
                int lim = output.Count;
                output[num] = (byte)((lim & 0xFF000000) >> 24);
                output[num+1] = (byte)((lim & 0x00FF0000) >> 16);
                output[num+2] = (byte)((lim & 0x0000FF00) >> 8);
                output[num+3] = (byte)((lim & 0x000000FF));

                foreach(char c in texts[i])
                {
                    output.Add((byte)(c >> 8 & 0xFF));
                    output.Add((byte)(c & 0xFF));
                }
                output.Add(0);

                while (output.Count % 4 > 0)
                {
                    output.Add(0);
                }
            }

            return output.ToArray();
        }
    }
}
