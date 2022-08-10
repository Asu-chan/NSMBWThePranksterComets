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

namespace PranksterToolbox.ReplayDataEditor
{
    public partial class Main : Form
    {
        public Main()
        {
            InitializeComponent();
        }

        ReplayData replayData = new ReplayData();
        string path = "";

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog dialog = new OpenFileDialog())
            {
                string output;
                dialog.Filter = "NSMBW Replay Data File|*.bin|All files (*.*)|*.*";
                dialog.FilterIndex = 1;
                dialog.RestoreDirectory = true;
                if (dialog.ShowDialog() == DialogResult.OK)
                {
                    output = dialog.FileName;
                    if (replayData.loadFile(output))
                    {
                        refreshListBox(1);
                        propertiesGroupBox.Enabled = true;
                        hintLabels(true);
                        path = output;
                        this.Text = "Replay Data Editor - " + Path.GetFileName(output);

                        saveToolStripMenuItem.Enabled = true;
                        saveAsToolStripMenuItem.Enabled = true;
                    }
                }
            }
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            File.WriteAllBytes(path, replayData.saveAsBytes());
        }

        private void saveAsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveFileDialog textDialog;
            textDialog = new SaveFileDialog();
            textDialog.Filter = "NSMBW Replay Data File|*.bin|All files (*.*)|*.*";
            textDialog.DefaultExt = "bin";
            if (textDialog.ShowDialog() == DialogResult.OK)
            {
                //Stream things to get the saved path
                System.IO.Stream fileStream = textDialog.OpenFile();
                System.IO.StreamWriter sw = new System.IO.StreamWriter(fileStream);
                string outputPath = ((FileStream)(sw.BaseStream)).Name;
                sw.Close();
                path = outputPath;
                this.Text = "Replay Data Editor - " + Path.GetFileName(outputPath);

                //Save it

                saveToolStripMenuItem_Click(sender, e);
            }
        }

        public void hintLabels(bool state)
        {
            worldIDTranslateLabel.Visible = state;
            levelIDTranslateLabel.Visible = state;
            typeTranslateLabel.Visible = state;
            entranceTranslateLabel.Visible = state;
            frameCountTranslateLabel.Visible = state;
            areaTranslateLabel.Visible = state;
            costTranslateLabel.Visible = state;
            tag1CTranslateLabel.Visible = state;
            tag20TranslateLabel.Visible = state;
        }

        public void refreshListBox(int sel)
        {
            entryListBox.Items.Clear();
            for (int i = 0; i < replayData.entries.Count; i++)
            {
                entryListBox.Items.Add("Entry " + i);
            }
            entryListBox.SelectedIndex = sel - 1;
        }

        private void addEntryButton_Click(object sender, EventArgs e)
        {
            replayData.entries.Add(new ReplayDataEntry());
            refreshListBox(replayData.entries.Count);
            propertiesGroupBox.Enabled = true;
            hintLabels(true);
            saveAsToolStripMenuItem.Enabled = true;
            if (path != "")
            {
                saveToolStripMenuItem.Enabled = true;
            }
        }

        private void removeEntryButton_Click(object sender, EventArgs e)
        {
            replayData.entries.RemoveAt(entryListBox.SelectedIndex);
            refreshListBox(entryListBox.SelectedIndex);
            if (replayData.entries.Count == 0)
            {
                propertiesGroupBox.Enabled = false;
                hintLabels(false);
                saveToolStripMenuItem.Enabled = false;
                saveToolStripMenuItem.Enabled = false;
            }
        }

        private void entryListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            worldIDNumUpDown.Value = replayData.entries[entryListBox.SelectedIndex].worldID;
            levelIDNumUpDown.Value = replayData.entries[entryListBox.SelectedIndex].levelID;
            typeNumUpDown.Value = replayData.entries[entryListBox.SelectedIndex].type;
            entranceNumUpDown.Value = replayData.entries[entryListBox.SelectedIndex].entrance;
            frameCountNumUpDown.Value = replayData.entries[entryListBox.SelectedIndex].frameCount;
            areaNumUpDown.Value = replayData.entries[entryListBox.SelectedIndex].area;
            costNumUpDown.Value = replayData.entries[entryListBox.SelectedIndex].cost;
            tag1CNumUpDown.Value = replayData.entries[entryListBox.SelectedIndex]._1C;
            tag20NumUpDown.Value = replayData.entries[entryListBox.SelectedIndex]._20;

            worldIDNumUpDown_ValueChanged(sender, e);
            levelIDNumUpDown_ValueChanged(sender, e);
            typeNumUpDown_ValueChanged(sender, e);
            tagCNumUpDown_ValueChanged(sender, e);
            frameCountNumUpDown_ValueChanged(sender, e);
            tag14NumUpDown_ValueChanged(sender, e);
            costNumUpDown_ValueChanged(sender, e);
            tag1CNumUpDown_ValueChanged(sender, e);
            tag20NumUpDown_ValueChanged(sender, e);
        }

        private void worldIDNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            replayData.entries[entryListBox.SelectedIndex].worldID = (uint)worldIDNumUpDown.Value;

            if (worldIDNumUpDown.Value == 0xA) worldIDTranslateLabel.Text = "Last Entry";
            else if (worldIDNumUpDown.Value > 0xA) worldIDTranslateLabel.Text = "Invalid";
            else worldIDTranslateLabel.Text = "W" + (worldIDNumUpDown.Value + 1).ToString();
        }

        private void levelIDNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            replayData.entries[entryListBox.SelectedIndex].levelID = (uint)levelIDNumUpDown.Value;

            if (levelIDNumUpDown.Value == 21) levelIDTranslateLabel.Text = "Tower";
            else if (levelIDNumUpDown.Value == 23) levelIDTranslateLabel.Text = "Castle";
            else if (levelIDNumUpDown.Value == 35) levelIDTranslateLabel.Text = "Cannon";
            else if (levelIDNumUpDown.Value >= 25 && levelIDNumUpDown.Value <= 28) levelIDTranslateLabel.Text = "Toad House";
            else if (levelIDNumUpDown.Value >= 32 && levelIDNumUpDown.Value <= 34) levelIDTranslateLabel.Text = "Ambush";
            else if (levelIDNumUpDown.Value == 42) levelIDTranslateLabel.Text = "Last Entry";
            else if (levelIDNumUpDown.Value > 42) levelIDTranslateLabel.Text = "Invalid";
            else levelIDTranslateLabel.Text = (levelIDNumUpDown.Value + 1).ToString();
        }

        private void typeNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            replayData.entries[entryListBox.SelectedIndex].type = (uint)typeNumUpDown.Value;

            if (typeNumUpDown.Value == 0) typeTranslateLabel.Text = "Super Skills";
            else if (typeNumUpDown.Value == 1) typeTranslateLabel.Text = "Endless 1-Ups";
            else if (typeNumUpDown.Value == 2) typeTranslateLabel.Text = "Star Coin";
            else if (typeNumUpDown.Value == 3) typeTranslateLabel.Text = "Secret Goal";
            else if (typeNumUpDown.Value == 4) typeTranslateLabel.Text = "Last Entry";
            else typeTranslateLabel.Text = "Invalid";
        }

        private void tagCNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            replayData.entries[entryListBox.SelectedIndex].entrance = (uint)entranceNumUpDown.Value;

            if (entranceNumUpDown.Value == 0xFFFFFFFF) entranceTranslateLabel.Text = "Last Entry";
            else entranceTranslateLabel.Text = "0x" + ((uint)entranceNumUpDown.Value).ToString("X");
        }

        private void frameCountNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            replayData.entries[entryListBox.SelectedIndex].frameCount = (uint)frameCountNumUpDown.Value;

            if (frameCountNumUpDown.Value == 0xFFFFFFFF) frameCountTranslateLabel.Text = "Last Entry";
            else frameCountTranslateLabel.Text = "0x" + ((uint)frameCountNumUpDown.Value).ToString("X");
        }

        private void tag14NumUpDown_ValueChanged(object sender, EventArgs e)
        {
            replayData.entries[entryListBox.SelectedIndex].area = (uint)areaNumUpDown.Value;

            if (areaNumUpDown.Value == 4) areaTranslateLabel.Text = "Last Entry";
            else if (areaNumUpDown.Value > 4) areaTranslateLabel.Text = "Invalid";
            else areaTranslateLabel.Text = "0x" + ((uint)areaNumUpDown.Value).ToString("X");
        }

        private void costNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            replayData.entries[entryListBox.SelectedIndex].cost = (uint)costNumUpDown.Value;

            if (costNumUpDown.Value == 0xFFFFFFFF) costTranslateLabel.Text = "Last Entry";
            else costTranslateLabel.Text = ((uint)costNumUpDown.Value).ToString("X");
        }

        private void tag1CNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            replayData.entries[entryListBox.SelectedIndex]._1C = (uint)tag1CNumUpDown.Value;

            if (tag1CNumUpDown.Value == 16) tag1CTranslateLabel.Text = "Last Entry";
            else if (tag1CNumUpDown.Value > 16) tag1CTranslateLabel.Text = "Invalid";
            else tag1CTranslateLabel.Text = "0x" + ((uint)tag1CNumUpDown.Value).ToString("X");
        }

        private void tag20NumUpDown_ValueChanged(object sender, EventArgs e)
        {
            replayData.entries[entryListBox.SelectedIndex]._20 = (uint)tag20NumUpDown.Value;

            if (tag20NumUpDown.Value == 0xFFFFFFFF) tag20TranslateLabel.Text = "Last Entry";
            else tag20TranslateLabel.Text = "0x" + ((uint)tag20NumUpDown.Value).ToString("X");
        }
    }

    public class ReplayData
    {
        public List<ReplayDataEntry> entries = new List<ReplayDataEntry>();

        public bool loadFile(string path)
        {
            entries = new List<ReplayDataEntry>();

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

            uint length = (uint)(file.Length - (file.Length % 0x24));
            uint entryCount = length / 0x24;

            for(int i = 0; i < entryCount; i++)
            {
                ReplayDataEntry entry = new ReplayDataEntry();

                int idx = i * 0x24;
                entry.worldID =    BitConverter.ToUInt32(file.Skip(idx).Take(4).Reverse().ToArray(), 0);
                entry.levelID =    BitConverter.ToUInt32(file.Skip(idx+4).Take(4).Reverse().ToArray(), 0);
                entry.type =       BitConverter.ToUInt32(file.Skip(idx+8).Take(4).Reverse().ToArray(), 0);
                entry.entrance =         BitConverter.ToUInt32(file.Skip(idx+0xC).Take(4).Reverse().ToArray(), 0);
                entry.frameCount = BitConverter.ToUInt32(file.Skip(idx+0x10).Take(4).Reverse().ToArray(), 0);
                entry.area =        BitConverter.ToUInt32(file.Skip(idx+0x14).Take(4).Reverse().ToArray(), 0);
                entry.cost =       BitConverter.ToUInt32(file.Skip(idx+0x18).Take(4).Reverse().ToArray(), 0);
                entry._1C =        BitConverter.ToUInt32(file.Skip(idx+0x1C).Take(4).Reverse().ToArray(), 0);
                entry._20 =        BitConverter.ToUInt32(file.Skip(idx+0x20).Take(4).Reverse().ToArray(), 0);

                entries.Add(entry);
            }

            return true;
        }

        public byte[] saveAsBytes()
        {
            List<byte> file = new List<byte>();

            foreach(ReplayDataEntry entry in entries)
            {
                file.Add((byte)((entry.worldID & 0xFF000000) >> 24));
                file.Add((byte)((entry.worldID & 0x00FF0000) >> 16));
                file.Add((byte)((entry.worldID & 0x0000FF00) >> 8));
                file.Add((byte)((entry.worldID & 0x000000FF)));

                file.Add((byte)((entry.levelID & 0xFF000000) >> 24));
                file.Add((byte)((entry.levelID & 0x00FF0000) >> 16));
                file.Add((byte)((entry.levelID & 0x0000FF00) >> 8));
                file.Add((byte)((entry.levelID & 0x000000FF)));

                file.Add((byte)((entry.type & 0xFF000000) >> 24));
                file.Add((byte)((entry.type & 0x00FF0000) >> 16));
                file.Add((byte)((entry.type & 0x0000FF00) >> 8));
                file.Add((byte)((entry.type & 0x000000FF)));

                file.Add((byte)((entry.entrance & 0xFF000000) >> 24));
                file.Add((byte)((entry.entrance & 0x00FF0000) >> 16));
                file.Add((byte)((entry.entrance & 0x0000FF00) >> 8));
                file.Add((byte)((entry.entrance & 0x000000FF)));

                file.Add((byte)((entry.frameCount & 0xFF000000) >> 24));
                file.Add((byte)((entry.frameCount & 0x00FF0000) >> 16));
                file.Add((byte)((entry.frameCount & 0x0000FF00) >> 8));
                file.Add((byte)((entry.frameCount & 0x000000FF)));

                file.Add((byte)((entry.area & 0xFF000000) >> 24));
                file.Add((byte)((entry.area & 0x00FF0000) >> 16));
                file.Add((byte)((entry.area & 0x0000FF00) >> 8));
                file.Add((byte)((entry.area & 0x000000FF)));

                file.Add((byte)((entry.cost & 0xFF000000) >> 24));
                file.Add((byte)((entry.cost & 0x00FF0000) >> 16));
                file.Add((byte)((entry.cost & 0x0000FF00) >> 8));
                file.Add((byte)((entry.cost & 0x000000FF)));

                file.Add((byte)((entry._1C & 0xFF000000) >> 24));
                file.Add((byte)((entry._1C & 0x00FF0000) >> 16));
                file.Add((byte)((entry._1C & 0x0000FF00) >> 8));
                file.Add((byte)((entry._1C & 0x000000FF)));

                file.Add((byte)((entry._20 & 0xFF000000) >> 24));
                file.Add((byte)((entry._20 & 0x00FF0000) >> 16));
                file.Add((byte)((entry._20 & 0x0000FF00) >> 8));
                file.Add((byte)((entry._20 & 0x000000FF)));
            }

            return file.ToArray();
        }
    }

    public class ReplayDataEntry
    {
        public uint worldID;
        public uint levelID;
        public uint type;
        public uint entrance;
        public uint frameCount;
        public uint area;
        public uint cost;
        public uint _1C;
        public uint _20;
    }

}
