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

namespace PranksterToolbox.BonusLevelsEditor
{
    public partial class Main : Form
    {
        public Main()
        {
            InitializeComponent();
        }

        BonusLevels bonusLevels = new BonusLevels();
        string path = "";

        private void pageListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            authorQuoteRichTextBox.Text = bonusLevels.bonusLevels[pageListBox.SelectedIndex].authorQuote.Replace("\n", "\r\n");
            authorNameTextBox.Text = bonusLevels.bonusLevels[pageListBox.SelectedIndex].authorName.Replace("\n", "\r\n");
            authorPFPNumericUpDown.Value = bonusLevels.bonusLevels[pageListBox.SelectedIndex].authorID;

            levelFilenameWNumericUpDown.Value = bonusLevels.bonusLevels[pageListBox.SelectedIndex].filenameW + 1;
            levelFilenameLNumericUpDown.Value = bonusLevels.bonusLevels[pageListBox.SelectedIndex].filenameL + 1;
            levelDisplayNameWNumericUpDown.Value = bonusLevels.bonusLevels[pageListBox.SelectedIndex].displaynameW;
            levelDisplayNameLNumericUpDown.Value = bonusLevels.bonusLevels[pageListBox.SelectedIndex].displaynameL;

            topAuthorTextColorTextBox.Text = bonusLevels.bonusLevels[pageListBox.SelectedIndex].topAuthorColor.ToString("X8");
            bottomAuthorTextColorTextBox.Text = bonusLevels.bonusLevels[pageListBox.SelectedIndex].bottomAuthorColor.ToString("X8");
            topLevelTextColorTextBox.Text = bonusLevels.bonusLevels[pageListBox.SelectedIndex].topLevelColor.ToString("X8");
            bottomLevelTextColorTextBox.Text = bonusLevels.bonusLevels[pageListBox.SelectedIndex].bottomLevelColor.ToString("X8");
        }

        private void addPageButton_Click(object sender, EventArgs e)
        {
            bonusLevels.bonusLevels.Add(new BonusLevel());
            refreshListBox(bonusLevels.bonusLevels.Count);
            propertiesGroupBox.Enabled = true;
            saveAsToolStripMenuItem.Enabled = true;
            if (path != "")
            {
                saveToolStripMenuItem.Enabled = true;
            }
        }

        private void removePageButton_Click(object sender, EventArgs e)
        {
            bonusLevels.bonusLevels.RemoveAt(pageListBox.SelectedIndex);
            refreshListBox(pageListBox.SelectedIndex);
            if (bonusLevels.bonusLevels.Count == 0)
            {
                propertiesGroupBox.Enabled = false;
                saveToolStripMenuItem.Enabled = false;
                saveToolStripMenuItem.Enabled = false;
            }
        }

        public void refreshListBox(int sel)
        {
            pageListBox.Items.Clear();
            for (int i = 0; i < bonusLevels.bonusLevels.Count; i++)
            {
                pageListBox.Items.Add("Bonus Level " + i);
            }
            pageListBox.SelectedIndex = sel - 1;
        }

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog dialog = new OpenFileDialog())
            {
                string output;
                dialog.Filter = "Prankster Bonus Levels File|*.bin|All files (*.*)|*.*";
                dialog.FilterIndex = 1;
                dialog.RestoreDirectory = true;
                if (dialog.ShowDialog() == DialogResult.OK)
                {
                    output = dialog.FileName;
                    if (bonusLevels.loadFile(output))
                    {
                        refreshListBox(1);
                        propertiesGroupBox.Enabled = true;
                        path = output;
                        this.Text = "Prankster Bonus Levels Editor - " + Path.GetFileName(output);

                        saveToolStripMenuItem.Enabled = true;
                        saveAsToolStripMenuItem.Enabled = true;
                    }
                }
            }
        }

        private void openOldToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog dialog = new OpenFileDialog())
            {
                string output;
                dialog.Filter = "Prankster Bonus Levels File|*.bin|All files (*.*)|*.*";
                dialog.FilterIndex = 1;
                dialog.RestoreDirectory = true;
                if (dialog.ShowDialog() == DialogResult.OK)
                {
                    output = dialog.FileName;
                    if (bonusLevels.loadOldFile(output))
                    {
                        refreshListBox(1);
                        propertiesGroupBox.Enabled = true;
                        path = output;
                        this.Text = "Prankster Bonus Levels Editor - " + Path.GetFileName(output);

                        saveToolStripMenuItem.Enabled = true;
                        saveAsToolStripMenuItem.Enabled = true;
                    }
                }
            }
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            File.WriteAllBytes(path, bonusLevels.saveAsBytes());
        }

        private void saveAsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveFileDialog textDialog;
            textDialog = new SaveFileDialog();
            textDialog.Filter = "Prankster Bonus Levels File|*.bin|All files (*.*)|*.*";
            textDialog.DefaultExt = "bin";
            if (textDialog.ShowDialog() == DialogResult.OK)
            {
                //Stream things to get the saved path
                System.IO.Stream fileStream = textDialog.OpenFile();
                System.IO.StreamWriter sw = new System.IO.StreamWriter(fileStream);
                string outputPath = ((FileStream)(sw.BaseStream)).Name;
                sw.Close();
                path = outputPath;
                this.Text = "Prankster Bonus Levels Editor - " + Path.GetFileName(outputPath);

                //Save it
                saveToolStripMenuItem_Click(sender, e);
            }
        }

        private void authorQuoteRichTextBox_TextChanged(object sender, EventArgs e)
        {
            bonusLevels.bonusLevels[pageListBox.SelectedIndex].authorQuote = authorQuoteRichTextBox.Text.Replace("\r", "");
        }

        private void authorNameTextBox_TextChanged(object sender, EventArgs e)
        {
            bonusLevels.bonusLevels[pageListBox.SelectedIndex].authorName = authorNameTextBox.Text.Replace("\r", "");
        }

        private void authorPFPNumericUpDown_ValueChanged(object sender, EventArgs e)
        {
            bonusLevels.bonusLevels[pageListBox.SelectedIndex].authorID = (uint)authorPFPNumericUpDown.Value;
        }

        private void levelFilenameWNumericUpDown_ValueChanged(object sender, EventArgs e)
        {
            bonusLevels.bonusLevels[pageListBox.SelectedIndex].filenameW = (byte)(levelFilenameWNumericUpDown.Value - 1);
        }

        private void levelFilenameLNumericUpDown_ValueChanged(object sender, EventArgs e)
        {
            bonusLevels.bonusLevels[pageListBox.SelectedIndex].filenameL = (byte)(levelFilenameLNumericUpDown.Value - 1);
        }

        private void levelDisplayNameWNumericUpDown_ValueChanged(object sender, EventArgs e)
        {
            bonusLevels.bonusLevels[pageListBox.SelectedIndex].displaynameW = (byte)levelDisplayNameWNumericUpDown.Value;
        }

        private void levelDisplayNameLNumericUpDown_ValueChanged(object sender, EventArgs e)
        {
            bonusLevels.bonusLevels[pageListBox.SelectedIndex].displaynameL = (byte)levelDisplayNameLNumericUpDown.Value;
        }

        List<char> hexChars = new List<char>(new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f' });
        string prevValue = "";

        private void filterHexColorTextBox(object sender)
        {
            if ((sender as TextBox).Text.Any(x => !hexChars.Contains(x)))
            {
                (sender as TextBox).Text = prevValue;
                MessageBox.Show("Please input an hex color code in the RRGGBBAA format.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void topAuthorTextColorTextBox_TextChanged(object sender, EventArgs e)
        {
            filterHexColorTextBox(sender);

            bonusLevels.bonusLevels[pageListBox.SelectedIndex].topAuthorColor = Convert.ToUInt32(topAuthorTextColorTextBox.Text, 16);
        }

        private void bottomAuthorTextColorTextBox_TextChanged(object sender, EventArgs e)
        {
            filterHexColorTextBox(sender);

            bonusLevels.bonusLevels[pageListBox.SelectedIndex].bottomAuthorColor = Convert.ToUInt32(bottomAuthorTextColorTextBox.Text, 16);
        }

        private void topLevelTextColorTextBox_TextChanged(object sender, EventArgs e)
        {
            filterHexColorTextBox(sender);

            bonusLevels.bonusLevels[pageListBox.SelectedIndex].topLevelColor = Convert.ToUInt32(topLevelTextColorTextBox.Text, 16);
        }

        private void bottomLevelTextColorTextBox_TextChanged(object sender, EventArgs e)
        {
            filterHexColorTextBox(sender);

            bonusLevels.bonusLevels[pageListBox.SelectedIndex].bottomLevelColor = Convert.ToUInt32(bottomLevelTextColorTextBox.Text, 16);
        }

        private void colorTextBoxes_KeyPress(object sender, System.Windows.Forms.KeyPressEventArgs e)
        {
            prevValue = (sender as TextBox).Text;
            Console.WriteLine("Handling \"" + e.KeyChar + "\"");
            if(!hexChars.Contains(e.KeyChar) && e.KeyChar >= 0x20)
            {
                MessageBox.Show("Please input an hex color code in the RRGGBBAA format.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information);
                e.Handled = true;
            }
        }
    }
}
