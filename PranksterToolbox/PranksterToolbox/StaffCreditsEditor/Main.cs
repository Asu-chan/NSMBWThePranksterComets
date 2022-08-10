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

namespace PranksterToolbox.StaffCreditsEditor
{
    public partial class Main : Form
    {
        public Main()
        {
            InitializeComponent();
        }

        StaffCredits staffCredits = new StaffCredits();
        string path = "";

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog dialog = new OpenFileDialog())
            {
                string output;
                dialog.Filter = "Prankster Staff Credits File|*.bin|All files (*.*)|*.*";
                dialog.FilterIndex = 1;
                dialog.RestoreDirectory = true;
                if (dialog.ShowDialog() == DialogResult.OK)
                {
                    output = dialog.FileName;
                    if (staffCredits.loadFile(output))
                    {
                        refreshListBox(1);
                        propertiesGroupBox.Enabled = true;
                        path = output;
                        this.Text = "Prankster Staff Credits Editor - " + Path.GetFileName(output);

                        saveToolStripMenuItem.Enabled = true;
                        saveAsToolStripMenuItem.Enabled = true;
                    }
                }
            }
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            File.WriteAllBytes(path, staffCredits.saveAsBytes());
        }

        private void saveAsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveFileDialog textDialog;
            textDialog = new SaveFileDialog();
            textDialog.Filter = "Prankster Staff Credits File|*.bin|All files (*.*)|*.*";
            textDialog.DefaultExt = "bin";
            if (textDialog.ShowDialog() == DialogResult.OK)
            {
                //Stream things to get the saved path
                System.IO.Stream fileStream = textDialog.OpenFile();
                System.IO.StreamWriter sw = new System.IO.StreamWriter(fileStream);
                string outputPath = ((FileStream)(sw.BaseStream)).Name;
                sw.Close();
                path = outputPath;
                this.Text = "Prankster Staff Credits Editor - " + Path.GetFileName(outputPath);

                //Save it
                saveToolStripMenuItem_Click(sender, e);
            }
        }

        public void refreshListBox(int sel)
        {
            pageListBox.Items.Clear();
            for (int i = 0; i < staffCredits.pages.Count; i++)
            {
                pageListBox.Items.Add("Page " + i);
            }
            pageListBox.SelectedIndex = sel - 1;
        }

        private void pageListBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            StaffCreditsPage currentPage = staffCredits.pages[pageListBox.SelectedIndex];

            doPropChange = false;

            titleTextBox1.Text = currentPage.title1;
            titleTextBox2.Text = currentPage.title2;

            string contentTB = "";

            Console.WriteLine("Loading " + currentPage.contents1.Count + " + " + currentPage.contents2.Count + " names.");
            if (currentPage.contents1.Count > 0)
            {
                foreach (string str in currentPage.contents1) contentTB += str + "\r\n";
                contentTB = contentTB.Substring(0, contentTB.Length - 2);
                contentTextBox1.Text = contentTB;
            }
            else contentTextBox1.Text = "";

            if (currentPage.contents2.Count > 0)
            {
                contentTB = "";
                foreach (string str in currentPage.contents2) contentTB += str + "\r\n";
                contentTB = contentTB.Substring(0, contentTB.Length - 2);
                contentTextBox2.Text = contentTB;
            }
            else contentTextBox2.Text = "";

            durationNumUpDown.Value = currentPage.frameDuration;

            doPropChange = true;
        }

        private void addPageButton_Click(object sender, EventArgs e)
        {
            staffCredits.pages.Add(new StaffCreditsPage());
            refreshListBox(staffCredits.pages.Count);
            propertiesGroupBox.Enabled = true;
            saveAsToolStripMenuItem.Enabled = true;
            if (path != "")
            {
                saveToolStripMenuItem.Enabled = true;
            }
        }

        private void removePageButton_Click(object sender, EventArgs e)
        {
            staffCredits.pages.RemoveAt(pageListBox.SelectedIndex);
            refreshListBox(pageListBox.SelectedIndex);
            if (staffCredits.pages.Count == 0)
            {
                propertiesGroupBox.Enabled = false;
                saveToolStripMenuItem.Enabled = false;
                saveToolStripMenuItem.Enabled = false;
            }
        }

        /*
        private void titleTextBox1_TextChanged(object sender, EventArgs e)
        {
            staffCredits.pages[pageListBox.SelectedIndex].title1 = titleTextBox1.Text;
        }

        private void titleTextBox2_TextChanged(object sender, EventArgs e)
        {
            staffCredits.pages[pageListBox.SelectedIndex].title2 = titleTextBox2.Text;
        }

        private void contentTextBox1_TextChanged(object sender, EventArgs e)
        {
            saveContents(ref staffCredits.pages[pageListBox.SelectedIndex].contents1, contentTextBox1.Text);
        }

        private void contentTextBox2_TextChanged(object sender, EventArgs e)
        {
            saveContents(ref staffCredits.pages[pageListBox.SelectedIndex].contents2, contentTextBox2.Text);
        }

        public void saveContents(ref string[] title, string val)
        {
            title = new string[0];
            string fval = val.Replace("\r\n", "\n");
            foreach(string line in val.Split('\n'))
            {
                title.Append(line);
            }
        }
        */

        bool doPropChange = true;
        private void pageProperty_Changed(object sender, EventArgs e)
        {
            if(doPropChange) changesMade();
        }

        void changesMade()
        {
            pageListBox.Enabled = false;
            validateButton.Enabled = true;
        }

        private void validateButton_Click(object sender, EventArgs e)
        {
            string title1 = titleTextBox1.Text;
            string title2 = titleTextBox2.Text;
            string[] contents1 = contentTextBox1.Text.Replace("\r\n", "\n").Split('\n');
            string[] contents2 = contentTextBox2.Text.Replace("\r\n", "\n").Split('\n');
            if(contents1.Length == 1 && contents1[0] == "") contents1 = new string[0];
            if(contents2.Length == 1 && contents2[0] == "") contents2 = new string[0];

            if(title1 == "")
            {
                MessageBox.Show("There must be a first title", "Invalid properties", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            if(contents1.Length + contents2.Length > 6)
            {
                MessageBox.Show("There can only be 6 content lines per page", "Invalid properties", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            if(title2 == "" && contents2.Length > 0)
            {
                MessageBox.Show("You wrote lines in the second content text box, but no title for them", "Invalid properties", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            if(title2 != "" && (contents1.Length % 2) != 0)
            {
                MessageBox.Show("If you have a second title, you need an even number of first content", "Invalid properties", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            staffCredits.pages[pageListBox.SelectedIndex].title1 = title1;
            staffCredits.pages[pageListBox.SelectedIndex].title2 = title2;
            staffCredits.pages[pageListBox.SelectedIndex].contents1 = contents1.ToList();
            staffCredits.pages[pageListBox.SelectedIndex].contents2 = contents2.ToList();
            staffCredits.pages[pageListBox.SelectedIndex].frameDuration = (ushort)durationNumUpDown.Value;

            validateButton.Enabled = false;
            pageListBox.Enabled = true;
            
        }
    }
}
