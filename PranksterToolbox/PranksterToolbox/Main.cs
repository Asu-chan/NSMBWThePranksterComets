using Microsoft.VisualBasic;
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

namespace PranksterToolbox
{
    public partial class Main : Form
    {
        public Main()
        {
            InitializeComponent();
        }

        private void openingEditorButton_Click(object sender, EventArgs e)
        {
            using(OpeningEditor.Main tool = new OpeningEditor.Main())
            {
                tool.ShowDialog();
            }
        }

        private void bonusLevelsEditorButton_Click(object sender, EventArgs e)
        {
            using (BonusLevelsEditor.Main tool = new BonusLevelsEditor.Main())
            {
                tool.ShowDialog();
            }
        }

        private void staffCreditsEditorButton_Click(object sender, EventArgs e)
        {
            using (StaffCreditsEditor.Main tool = new StaffCreditsEditor.Main())
            {
                tool.ShowDialog();
            }
        }

        private void raceTrimmerButton_Click(object sender, EventArgs e) // Not making a whole Form for that, input boxes are good enough
        {
            // Getting the memdump path & verifying it exists

            string mempath = Interaction.InputBox("It usually is \"Your documents/Dolphin Emulator/Dump/mem1.raw\"", "What is the path to your Dolphin memory dump?");
            if (mempath == "")
                return;

            if (!File.Exists(mempath)) {
                MessageBox.Show("File \"" + mempath + "\" does not exist.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // Getting the pointer & verifying it as well

            string pointerstr = Interaction.InputBox("It it given in Dolphin's OSReport output.\r\nPlease input in hexadecimal.", "What is the pointer to your Race Recorder's saving buffer?");
            if (pointerstr == "")
                return;

            if (pointerstr.Contains("0x")) { pointerstr = pointerstr.Replace("0x", ""); }

            uint pointer = 0;
            try
            {
                pointer = Convert.ToUInt32(pointerstr, 16);
            }
            catch(Exception ex)
            {
                MessageBox.Show("\"" + pointerstr + "\" is not a valid pointer.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            if(pointer < 0x80000000 || pointer >= 0x90000000)
            {
                MessageBox.Show("\"" + pointerstr + "\" is out of range.\r\nIt is meant to be between 0x80000000 and 0x90000000.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            pointer -= 0x80000000;

            // Getting the frame count

            string frameCountStr = Interaction.InputBox("It it given in Dolphin's OSReport output.", "What is the number of frames of the race you recorded?");
            if (frameCountStr == "")
                return;

            uint frameCount = 0;
            try
            {
                frameCount = Convert.ToUInt32(frameCountStr, 10);
            }
            catch (Exception ex)
            {
                MessageBox.Show("\"" + frameCountStr + "\" is not a frame count.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // Doing the magic

            List<byte> bytes = new List<byte>();
            try
            {
                FileStream file = File.OpenRead(mempath);

                file.Position = pointer;

                for (int i = 0; i < (frameCount * 0x24); i++)
                {
                    bytes.Add((byte)file.ReadByte());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("An error has occured: \"" + ex.Message + "\"", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // Saving

            SaveFileDialog textDialog;
            textDialog = new SaveFileDialog();
            textDialog.Filter = "Cosmic Race file|*.race|All files (*.*)|*.*";
            textDialog.DefaultExt = "race";
            if (textDialog.ShowDialog() == DialogResult.OK)
            {
                System.IO.Stream fileStream = textDialog.OpenFile();
                System.IO.StreamWriter sw = new System.IO.StreamWriter(fileStream);
                string outputPath = ((FileStream)(sw.BaseStream)).Name;
                sw.Close();

                File.WriteAllBytes(outputPath, bytes.ToArray());
            }
            else return;

            // Done

            MessageBox.Show("All done!", "", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void raceEditorButton_Click(object sender, EventArgs e)
        {
            using (CosmicRaceEditor.Main tool = new CosmicRaceEditor.Main())
            {
                tool.ShowDialog();
            }
        }

        private void replayDataEditorButton_Click(object sender, EventArgs e)
        {
            using (ReplayDataEditor.Main tool = new ReplayDataEditor.Main())
            {
                tool.ShowDialog();
            }
        }

        private void openingEditorInfoButton_Click(object sender, EventArgs e)
        {
            MessageBox.Show("This tool allows you to edit the Opening.bin file located in the game's NewerRes folder.\r\n" +
                            "\r\n" +
                            "This file contains information about the game's opening cutscene, such as:\r\n" +
                            " - Page informations\r\n" +
                            " - Pictures to display\r\n" +
                            " - Text to write\r\n",
                            "Opening Editor Help & Information",
                            MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void bonusLevelEditorInfoButton_Click(object sender, EventArgs e)
        {
            MessageBox.Show("This tool allows you to edit the BonusLevels.bin file located in the game's NewerRes folder.\r\n" +
                            "\r\n" +
                            "This file contains information about the game's bonus levels, such as:\r\n" +
                            " - Level IDs\r\n" +
                            " - Authors names\r\n" +
                            " - Text colors\r\n",
                            "Bonus Level Editor Help & Information",
                            MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void staffCreditsEditorInfoButton_Click(object sender, EventArgs e)
        {
            MessageBox.Show("This tool allows you to edit the StaffCredits.bin file located in the game's NewerRes folder.\r\n" +
                            "\r\n" +
                            "This file contains information about the game's credits, such as:\r\n" +
                            " - Staff names\r\n" +
                            " - Staff roles\r\n",
                            "Staff Credits Editor Help & Information",
                            MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void raceTrimmerInfoButton_Click(object sender, EventArgs e)
        {
            MessageBox.Show("This tool allows you to trim Cosmic Mario race files off of Dolphin memory dumps.\r\n" +
                            "\r\n" +
                            "These files contain player information for each frame of the race so Cosmic Mario can mimick them.\r\n" +
                            "For this tool to work, you need to record your race using the Race Recorder sprite, and then get its buffer's pointer and frame count using Dolphin's OSReport output.\r\n\r\n" +
                            "Please keep in mind that this tool was not really meant for the public to use.\r\n",
                            "Cosmic Race Trimmer Help & Information",
                            MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void raceEditorInfoButton_Click(object sender, EventArgs e)
        {

        }

        private void replayDataEditorInfoButton_Click(object sender, EventArgs e)
        {

        }
    }
}
