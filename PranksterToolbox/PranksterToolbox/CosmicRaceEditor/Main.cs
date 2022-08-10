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

namespace PranksterToolbox.CosmicRaceEditor
{

    public partial class Main : Form
    {
        public Main()
        {
            InitializeComponent();
        }

        public static float fconv = 360.0f / (float)0xFFFF;

        CosmicRace cosmicRace = new CosmicRace();
        string path = "";

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog dialog = new OpenFileDialog())
            {
                string output;
                dialog.Filter = "Prankster Cosmic Race file|*.race|All files (*.*)|*.*";
                dialog.FilterIndex = 1;
                dialog.RestoreDirectory = true;
                if (dialog.ShowDialog() == DialogResult.OK)
                {
                    output = dialog.FileName;
                    if (cosmicRace.loadFile(output))
                    {
                        refreshListBox(1);
                        propertiesGroupBox.Enabled = true;
                        path = output;
                        this.Text = "Cosmic Race Editor - " + Path.GetFileName(output);

                        saveToolStripMenuItem.Enabled = true;
                        saveAsToolStripMenuItem.Enabled = true;
                    }
                }
            }
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            File.WriteAllBytes(path, cosmicRace.saveAsBytes());
        }

        private void saveAsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveFileDialog textDialog;
            textDialog = new SaveFileDialog();
            textDialog.Filter = "Prankster Cosmic Race file|*.race|All files (*.*)|*.*";
            textDialog.DefaultExt = "race";
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

        public void refreshListBox(int sel)
        {
            frameListBox.Items.Clear();
            for (int i = 0; i < cosmicRace.frames.Count; i++)
            {
                frameListBox.Items.Add("Frame " + i);
            }
            frameListBox.SelectedIndex = sel - 1;
        }

        private void addEntryButton_Click(object sender, EventArgs e)
        {
            cosmicRace.frames.Add(new CosmicRaceFrame());
            refreshListBox(cosmicRace.frames.Count);
            propertiesGroupBox.Enabled = true;
            saveAsToolStripMenuItem.Enabled = true;
            if (path != "")
            {
                saveToolStripMenuItem.Enabled = true;
            }
        }

        private void removeEntryButton_Click(object sender, EventArgs e)
        {
            cosmicRace.frames.RemoveAt(frameListBox.SelectedIndex);
            refreshListBox(frameListBox.SelectedIndex);
            if (cosmicRace.frames.Count == 0)
            {
                propertiesGroupBox.Enabled = false;
                saveToolStripMenuItem.Enabled = false;
                saveToolStripMenuItem.Enabled = false;
            }
        }

        private void frameListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            xPosNumUpDown.Value = (decimal)cosmicRace.frames[frameListBox.SelectedIndex].pos.x;
            yPosNumUpDown.Value = (decimal)cosmicRace.frames[frameListBox.SelectedIndex].pos.y;
            zPosNumUpDown.Value = (decimal)cosmicRace.frames[frameListBox.SelectedIndex].pos.z;
            xRotNumUpDown.Value = (decimal)cosmicRace.frames[frameListBox.SelectedIndex].rot.x;
            yRotNumUpDown.Value = (decimal)cosmicRace.frames[frameListBox.SelectedIndex].rot.y;
            zRotNumUpDown.Value = (decimal)cosmicRace.frames[frameListBox.SelectedIndex].rot.z;
            animMainNumUpDown.Value = cosmicRace.frames[frameListBox.SelectedIndex].anim;
            animSubNumUpDown.Value = cosmicRace.frames[frameListBox.SelectedIndex].subAnim;
            frameMainNumUpDown.Value = (decimal)cosmicRace.frames[frameListBox.SelectedIndex].animFrame;
            frameSubNumUpDown.Value = (decimal)cosmicRace.frames[frameListBox.SelectedIndex].subAnimFrame;
        }

        private void xPosNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            cosmicRace.frames[frameListBox.SelectedIndex].pos.x = (float)xPosNumUpDown.Value;
        }

        private void yPosNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            cosmicRace.frames[frameListBox.SelectedIndex].pos.y = (float)yPosNumUpDown.Value;
        }

        private void zPosNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            cosmicRace.frames[frameListBox.SelectedIndex].pos.z = (float)zPosNumUpDown.Value;
        }

        private void xRotNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            cosmicRace.frames[frameListBox.SelectedIndex].rot.x = (float)xRotNumUpDown.Value;
        }

        private void yRotNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            cosmicRace.frames[frameListBox.SelectedIndex].rot.y = (float)yRotNumUpDown.Value;
        }

        private void zRotNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            cosmicRace.frames[frameListBox.SelectedIndex].rot.z = (float)zRotNumUpDown.Value;
        }

        private void animMainNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            cosmicRace.frames[frameListBox.SelectedIndex].anim = (int)animMainNumUpDown.Value;
        }

        private void animSubNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            cosmicRace.frames[frameListBox.SelectedIndex].subAnim = (int)animSubNumUpDown.Value;
        }

        private void frameMainNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            cosmicRace.frames[frameListBox.SelectedIndex].animFrame = (float)frameMainNumUpDown.Value;
        }

        private void frameSubNumUpDown_ValueChanged(object sender, EventArgs e)
        {
            cosmicRace.frames[frameListBox.SelectedIndex].subAnimFrame = (float)frameSubNumUpDown.Value;
        }
    }

    public class CosmicRace
    {
        public List<CosmicRaceFrame> frames = new List<CosmicRaceFrame>();

        public bool loadFile(string path)
        {
            frames = new List<CosmicRaceFrame>();

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
                CosmicRaceFrame frame = new CosmicRaceFrame();

                int idx = i * 0x24;
                frame.pos.x =        BitConverter.ToSingle(file.Skip(idx).Take(4).Reverse().ToArray(), 0);
                frame.pos.y =        BitConverter.ToSingle(file.Skip(idx+4).Take(4).Reverse().ToArray(), 0);
                frame.pos.z =        BitConverter.ToSingle(file.Skip(idx+8).Take(4).Reverse().ToArray(), 0);
                frame.rot.x = (float)BitConverter.ToUInt16(file.Skip(idx+0xC).Take(2).Reverse().ToArray(), 0) * Main.fconv;
                frame.rot.y = (float)BitConverter.ToUInt16(file.Skip(idx+0xE).Take(2).Reverse().ToArray(), 0) * Main.fconv;
                frame.rot.z = (float)BitConverter.ToUInt16(file.Skip(idx+0x10).Take(2).Reverse().ToArray(), 0) * Main.fconv;
                frame.anim =         BitConverter.ToInt32(file.Skip(idx+0x14).Take(4).Reverse().ToArray(), 0);
                frame.subAnim =      BitConverter.ToInt32(file.Skip(idx+0x18).Take(4).Reverse().ToArray(), 0);
                frame.animFrame =    BitConverter.ToSingle(file.Skip(idx+0x1C).Take(4).Reverse().ToArray(), 0);
                frame.subAnimFrame = BitConverter.ToSingle(file.Skip(idx+0x20).Take(4).Reverse().ToArray(), 0);

                if(frame.pos.y == -617.1651f) { frame.pos.y -= 5.0f; }

                frames.Add(frame);
            }

            return true;
        }

        public byte[] saveAsBytes()
        {
            List<byte> file = new List<byte>();

            foreach(CosmicRaceFrame frame in frames)
            {
                byte[] floatstuff = new byte[0];

                floatstuff = BitConverter.GetBytes(frame.pos.x);
                file.Add(floatstuff[3]);
                file.Add(floatstuff[2]);
                file.Add(floatstuff[1]);
                file.Add(floatstuff[0]);

                floatstuff = BitConverter.GetBytes(frame.pos.y);
                file.Add(floatstuff[3]);
                file.Add(floatstuff[2]);
                file.Add(floatstuff[1]);
                file.Add(floatstuff[0]);

                floatstuff = BitConverter.GetBytes(frame.pos.z);
                file.Add(floatstuff[3]);
                file.Add(floatstuff[2]);
                file.Add(floatstuff[1]);
                file.Add(floatstuff[0]);

                ushort rotx = (ushort)(frame.rot.x / Main.fconv);
                file.Add((byte)((rotx & 0x0000FF00) >> 8));
                file.Add((byte)((rotx & 0x000000FF)));

                ushort roty = (ushort)(frame.rot.y / Main.fconv);
                file.Add((byte)((roty & 0x0000FF00) >> 8));
                file.Add((byte)((roty & 0x000000FF)));

                ushort rotz = (ushort)(frame.rot.z / Main.fconv);
                file.Add((byte)((rotz & 0x0000FF00) >> 8));
                file.Add((byte)((rotz & 0x000000FF)));

                file.Add(0);
                file.Add(0);

                file.Add((byte)((frame.anim & 0xFF000000) >> 24));
                file.Add((byte)((frame.anim & 0x00FF0000) >> 16));
                file.Add((byte)((frame.anim & 0x0000FF00) >> 8));
                file.Add((byte)((frame.anim & 0x000000FF)));

                file.Add((byte)((frame.subAnim & 0xFF000000) >> 24));
                file.Add((byte)((frame.subAnim & 0x00FF0000) >> 16));
                file.Add((byte)((frame.subAnim & 0x0000FF00) >> 8));
                file.Add((byte)((frame.subAnim & 0x000000FF)));

                floatstuff = BitConverter.GetBytes(frame.animFrame);
                file.Add(floatstuff[3]);
                file.Add(floatstuff[2]);
                file.Add(floatstuff[1]);
                file.Add(floatstuff[0]);

                floatstuff = BitConverter.GetBytes(frame.subAnimFrame);
                file.Add(floatstuff[3]);
                file.Add(floatstuff[2]);
                file.Add(floatstuff[1]);
                file.Add(floatstuff[0]);
            }

            return file.ToArray();
        }
    }

    public class CosmicRaceFrame
    {
        public Vec3 pos = new Vec3();
        public Vec3 rot = new Vec3();
        public int anim;
        public int subAnim;
        public float animFrame;
        public float subAnimFrame;
    }

    public class Vec3
    {
        public float x, y, z;
    }

}
