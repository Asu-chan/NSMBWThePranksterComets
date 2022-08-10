using System.Windows.Forms;

namespace PranksterToolbox.BonusLevelsEditor
{
    partial class Main
    {
        /// <summary>
        /// Variable nécessaire au concepteur.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Nettoyage des ressources utilisées.
        /// </summary>
        /// <param name="disposing">true si les ressources managées doivent être supprimées ; sinon, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Code généré par le Concepteur Windows Form

        /// <summary>
        /// Méthode requise pour la prise en charge du concepteur - ne modifiez pas
        /// le contenu de cette méthode avec l'éditeur de code.
        /// </summary>
        private void InitializeComponent()
        {
            this.pageListBox = new System.Windows.Forms.ListBox();
            this.addPageButton = new System.Windows.Forms.Button();
            this.removePageButton = new System.Windows.Forms.Button();
            this.bonusLevelsMenuStrip = new System.Windows.Forms.MenuStrip();
            this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.openToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveAsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.openOldToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.propertiesGroupBox = new System.Windows.Forms.GroupBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.bottomLevelTextColorTextBox = new System.Windows.Forms.TextBox();
            this.topLevelTextColorTextBox = new System.Windows.Forms.TextBox();
            this.levelDisplayNameLabel = new System.Windows.Forms.Label();
            this.levelFilenameLabel = new System.Windows.Forms.Label();
            this.bottomTXTColorLabel = new System.Windows.Forms.Label();
            this.topTXTColorLabel = new System.Windows.Forms.Label();
            this.authorPFPLabel = new System.Windows.Forms.Label();
            this.authorNameLabel = new System.Windows.Forms.Label();
            this.levelFilenameLNumericUpDown = new System.Windows.Forms.NumericUpDown();
            this.levelDisplayNameWNumericUpDown = new System.Windows.Forms.NumericUpDown();
            this.levelDisplayNameLNumericUpDown = new System.Windows.Forms.NumericUpDown();
            this.levelFilenameWNumericUpDown = new System.Windows.Forms.NumericUpDown();
            this.authorPFPNumericUpDown = new System.Windows.Forms.NumericUpDown();
            this.authorNameTextBox = new System.Windows.Forms.TextBox();
            this.bottomAuthorTextColorTextBox = new System.Windows.Forms.TextBox();
            this.topAuthorTextColorTextBox = new System.Windows.Forms.TextBox();
            this.authorQuoteRichTextBox = new System.Windows.Forms.RichTextBox();
            this.authorQuoteLabel = new System.Windows.Forms.Label();
            this.bonusLevelsMenuStrip.SuspendLayout();
            this.propertiesGroupBox.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.levelFilenameLNumericUpDown)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.levelDisplayNameWNumericUpDown)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.levelDisplayNameLNumericUpDown)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.levelFilenameWNumericUpDown)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.authorPFPNumericUpDown)).BeginInit();
            this.SuspendLayout();
            // 
            // pageListBox
            // 
            this.pageListBox.FormattingEnabled = true;
            this.pageListBox.Location = new System.Drawing.Point(12, 38);
            this.pageListBox.Name = "pageListBox";
            this.pageListBox.Size = new System.Drawing.Size(156, 329);
            this.pageListBox.TabIndex = 0;
            this.pageListBox.SelectedIndexChanged += new System.EventHandler(this.pageListBox_SelectedIndexChanged);
            // 
            // addPageButton
            // 
            this.addPageButton.Location = new System.Drawing.Point(12, 373);
            this.addPageButton.Name = "addPageButton";
            this.addPageButton.Size = new System.Drawing.Size(75, 23);
            this.addPageButton.TabIndex = 1;
            this.addPageButton.Text = "Add";
            this.addPageButton.UseVisualStyleBackColor = true;
            this.addPageButton.Click += new System.EventHandler(this.addPageButton_Click);
            // 
            // removePageButton
            // 
            this.removePageButton.Location = new System.Drawing.Point(93, 373);
            this.removePageButton.Name = "removePageButton";
            this.removePageButton.Size = new System.Drawing.Size(75, 23);
            this.removePageButton.TabIndex = 2;
            this.removePageButton.Text = "Remove";
            this.removePageButton.UseVisualStyleBackColor = true;
            this.removePageButton.Click += new System.EventHandler(this.removePageButton_Click);
            // 
            // bonusLevelsMenuStrip
            // 
            this.bonusLevelsMenuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileToolStripMenuItem});
            this.bonusLevelsMenuStrip.Location = new System.Drawing.Point(0, 0);
            this.bonusLevelsMenuStrip.Name = "bonusLevelsMenuStrip";
            this.bonusLevelsMenuStrip.Size = new System.Drawing.Size(800, 24);
            this.bonusLevelsMenuStrip.TabIndex = 5;
            this.bonusLevelsMenuStrip.Text = "bonusLevelsMenuStrip";
            // 
            // fileToolStripMenuItem
            // 
            this.fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.openToolStripMenuItem,
            this.saveToolStripMenuItem,
            this.saveAsToolStripMenuItem,
            this.toolStripSeparator1,
            this.openOldToolStripMenuItem});
            this.fileToolStripMenuItem.Name = "fileToolStripMenuItem";
            this.fileToolStripMenuItem.Size = new System.Drawing.Size(37, 20);
            this.fileToolStripMenuItem.Text = "File";
            // 
            // openToolStripMenuItem
            // 
            this.openToolStripMenuItem.Name = "openToolStripMenuItem";
            this.openToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.O)));
            this.openToolStripMenuItem.Size = new System.Drawing.Size(205, 22);
            this.openToolStripMenuItem.Text = "Open...";
            this.openToolStripMenuItem.Click += new System.EventHandler(this.openToolStripMenuItem_Click);
            // 
            // saveToolStripMenuItem
            // 
            this.saveToolStripMenuItem.Name = "saveToolStripMenuItem";
            this.saveToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.S)));
            this.saveToolStripMenuItem.Size = new System.Drawing.Size(205, 22);
            this.saveToolStripMenuItem.Text = "Save";
            this.saveToolStripMenuItem.Click += new System.EventHandler(this.saveToolStripMenuItem_Click);
            // 
            // saveAsToolStripMenuItem
            // 
            this.saveAsToolStripMenuItem.Name = "saveAsToolStripMenuItem";
            this.saveAsToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)(((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Shift) 
            | System.Windows.Forms.Keys.S)));
            this.saveAsToolStripMenuItem.Size = new System.Drawing.Size(205, 22);
            this.saveAsToolStripMenuItem.Text = "Save As...";
            this.saveAsToolStripMenuItem.Click += new System.EventHandler(this.saveAsToolStripMenuItem_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(202, 6);
            this.toolStripSeparator1.Visible = false;
            // 
            // openOldToolStripMenuItem
            // 
            this.openOldToolStripMenuItem.Name = "openOldToolStripMenuItem";
            this.openOldToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)(((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Shift) 
            | System.Windows.Forms.Keys.O)));
            this.openOldToolStripMenuItem.Size = new System.Drawing.Size(205, 22);
            this.openOldToolStripMenuItem.Text = "Open Old...";
            this.openOldToolStripMenuItem.Visible = false;
            this.openOldToolStripMenuItem.Click += new System.EventHandler(this.openOldToolStripMenuItem_Click);
            // 
            // propertiesGroupBox
            // 
            this.propertiesGroupBox.Controls.Add(this.label1);
            this.propertiesGroupBox.Controls.Add(this.label2);
            this.propertiesGroupBox.Controls.Add(this.bottomLevelTextColorTextBox);
            this.propertiesGroupBox.Controls.Add(this.topLevelTextColorTextBox);
            this.propertiesGroupBox.Controls.Add(this.levelDisplayNameLabel);
            this.propertiesGroupBox.Controls.Add(this.levelFilenameLabel);
            this.propertiesGroupBox.Controls.Add(this.bottomTXTColorLabel);
            this.propertiesGroupBox.Controls.Add(this.topTXTColorLabel);
            this.propertiesGroupBox.Controls.Add(this.authorPFPLabel);
            this.propertiesGroupBox.Controls.Add(this.authorNameLabel);
            this.propertiesGroupBox.Controls.Add(this.levelFilenameLNumericUpDown);
            this.propertiesGroupBox.Controls.Add(this.levelDisplayNameWNumericUpDown);
            this.propertiesGroupBox.Controls.Add(this.levelDisplayNameLNumericUpDown);
            this.propertiesGroupBox.Controls.Add(this.levelFilenameWNumericUpDown);
            this.propertiesGroupBox.Controls.Add(this.authorPFPNumericUpDown);
            this.propertiesGroupBox.Controls.Add(this.authorNameTextBox);
            this.propertiesGroupBox.Controls.Add(this.bottomAuthorTextColorTextBox);
            this.propertiesGroupBox.Controls.Add(this.topAuthorTextColorTextBox);
            this.propertiesGroupBox.Controls.Add(this.authorQuoteRichTextBox);
            this.propertiesGroupBox.Controls.Add(this.authorQuoteLabel);
            this.propertiesGroupBox.Enabled = false;
            this.propertiesGroupBox.Location = new System.Drawing.Point(174, 32);
            this.propertiesGroupBox.Name = "propertiesGroupBox";
            this.propertiesGroupBox.Size = new System.Drawing.Size(614, 360);
            this.propertiesGroupBox.TabIndex = 22;
            this.propertiesGroupBox.TabStop = false;
            this.propertiesGroupBox.Text = "Properties";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(348, 244);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(123, 13);
            this.label1.TabIndex = 41;
            this.label1.Text = "Bottom Level Text Color:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(222, 244);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(109, 13);
            this.label2.TabIndex = 40;
            this.label2.Text = "Top Level Text Color:";
            // 
            // bottomLevelTextColorTextBox
            // 
            this.bottomLevelTextColorTextBox.Location = new System.Drawing.Point(351, 260);
            this.bottomLevelTextColorTextBox.MaxLength = 8;
            this.bottomLevelTextColorTextBox.Name = "bottomLevelTextColorTextBox";
            this.bottomLevelTextColorTextBox.Size = new System.Drawing.Size(120, 20);
            this.bottomLevelTextColorTextBox.TabIndex = 39;
            this.bottomLevelTextColorTextBox.TextChanged += new System.EventHandler(this.bottomLevelTextColorTextBox_TextChanged);
            this.bottomLevelTextColorTextBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.colorTextBoxes_KeyPress);
            // 
            // topLevelTextColorTextBox
            // 
            this.topLevelTextColorTextBox.Location = new System.Drawing.Point(225, 260);
            this.topLevelTextColorTextBox.MaxLength = 8;
            this.topLevelTextColorTextBox.Name = "topLevelTextColorTextBox";
            this.topLevelTextColorTextBox.Size = new System.Drawing.Size(120, 20);
            this.topLevelTextColorTextBox.TabIndex = 38;
            this.topLevelTextColorTextBox.TextChanged += new System.EventHandler(this.topLevelTextColorTextBox_TextChanged);
            this.topLevelTextColorTextBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.colorTextBoxes_KeyPress);
            // 
            // levelDisplayNameLabel
            // 
            this.levelDisplayNameLabel.AutoSize = true;
            this.levelDisplayNameLabel.Location = new System.Drawing.Point(115, 314);
            this.levelDisplayNameLabel.Name = "levelDisplayNameLabel";
            this.levelDisplayNameLabel.Size = new System.Drawing.Size(104, 13);
            this.levelDisplayNameLabel.TabIndex = 37;
            this.levelDisplayNameLabel.Text = "Level Display Name:";
            // 
            // levelFilenameLabel
            // 
            this.levelFilenameLabel.AutoSize = true;
            this.levelFilenameLabel.Location = new System.Drawing.Point(138, 288);
            this.levelFilenameLabel.Name = "levelFilenameLabel";
            this.levelFilenameLabel.Size = new System.Drawing.Size(81, 13);
            this.levelFilenameLabel.TabIndex = 36;
            this.levelFilenameLabel.Text = "Level Filename:";
            // 
            // bottomTXTColorLabel
            // 
            this.bottomTXTColorLabel.AutoSize = true;
            this.bottomTXTColorLabel.Location = new System.Drawing.Point(348, 205);
            this.bottomTXTColorLabel.Name = "bottomTXTColorLabel";
            this.bottomTXTColorLabel.Size = new System.Drawing.Size(128, 13);
            this.bottomTXTColorLabel.TabIndex = 35;
            this.bottomTXTColorLabel.Text = "Bottom Author Text Color:";
            // 
            // topTXTColorLabel
            // 
            this.topTXTColorLabel.AutoSize = true;
            this.topTXTColorLabel.Location = new System.Drawing.Point(222, 205);
            this.topTXTColorLabel.Name = "topTXTColorLabel";
            this.topTXTColorLabel.Size = new System.Drawing.Size(114, 13);
            this.topTXTColorLabel.TabIndex = 34;
            this.topTXTColorLabel.Text = "Top Author Text Color:";
            // 
            // authorPFPLabel
            // 
            this.authorPFPLabel.AutoSize = true;
            this.authorPFPLabel.Location = new System.Drawing.Point(457, 140);
            this.authorPFPLabel.Name = "authorPFPLabel";
            this.authorPFPLabel.Size = new System.Drawing.Size(89, 13);
            this.authorPFPLabel.TabIndex = 33;
            this.authorPFPLabel.Text = "Author(s) PFP ID:";
            // 
            // authorNameLabel
            // 
            this.authorNameLabel.AutoSize = true;
            this.authorNameLabel.Location = new System.Drawing.Point(457, 58);
            this.authorNameLabel.Name = "authorNameLabel";
            this.authorNameLabel.Size = new System.Drawing.Size(81, 13);
            this.authorNameLabel.TabIndex = 32;
            this.authorNameLabel.Text = "Author(s) name:";
            // 
            // levelFilenameLNumericUpDown
            // 
            this.levelFilenameLNumericUpDown.Location = new System.Drawing.Point(351, 286);
            this.levelFilenameLNumericUpDown.Maximum = new decimal(new int[] {
            42,
            0,
            0,
            0});
            this.levelFilenameLNumericUpDown.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.levelFilenameLNumericUpDown.Name = "levelFilenameLNumericUpDown";
            this.levelFilenameLNumericUpDown.Size = new System.Drawing.Size(120, 20);
            this.levelFilenameLNumericUpDown.TabIndex = 31;
            this.levelFilenameLNumericUpDown.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.levelFilenameLNumericUpDown.ValueChanged += new System.EventHandler(this.levelFilenameLNumericUpDown_ValueChanged);
            // 
            // levelDisplayNameWNumericUpDown
            // 
            this.levelDisplayNameWNumericUpDown.Location = new System.Drawing.Point(225, 312);
            this.levelDisplayNameWNumericUpDown.Maximum = new decimal(new int[] {
            255,
            0,
            0,
            0});
            this.levelDisplayNameWNumericUpDown.Name = "levelDisplayNameWNumericUpDown";
            this.levelDisplayNameWNumericUpDown.Size = new System.Drawing.Size(120, 20);
            this.levelDisplayNameWNumericUpDown.TabIndex = 30;
            this.levelDisplayNameWNumericUpDown.ValueChanged += new System.EventHandler(this.levelDisplayNameWNumericUpDown_ValueChanged);
            // 
            // levelDisplayNameLNumericUpDown
            // 
            this.levelDisplayNameLNumericUpDown.Location = new System.Drawing.Point(351, 312);
            this.levelDisplayNameLNumericUpDown.Maximum = new decimal(new int[] {
            255,
            0,
            0,
            0});
            this.levelDisplayNameLNumericUpDown.Name = "levelDisplayNameLNumericUpDown";
            this.levelDisplayNameLNumericUpDown.Size = new System.Drawing.Size(120, 20);
            this.levelDisplayNameLNumericUpDown.TabIndex = 29;
            this.levelDisplayNameLNumericUpDown.ValueChanged += new System.EventHandler(this.levelDisplayNameLNumericUpDown_ValueChanged);
            // 
            // levelFilenameWNumericUpDown
            // 
            this.levelFilenameWNumericUpDown.Location = new System.Drawing.Point(225, 286);
            this.levelFilenameWNumericUpDown.Maximum = new decimal(new int[] {
            10,
            0,
            0,
            0});
            this.levelFilenameWNumericUpDown.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.levelFilenameWNumericUpDown.Name = "levelFilenameWNumericUpDown";
            this.levelFilenameWNumericUpDown.Size = new System.Drawing.Size(120, 20);
            this.levelFilenameWNumericUpDown.TabIndex = 28;
            this.levelFilenameWNumericUpDown.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.levelFilenameWNumericUpDown.ValueChanged += new System.EventHandler(this.levelFilenameWNumericUpDown_ValueChanged);
            // 
            // authorPFPNumericUpDown
            // 
            this.authorPFPNumericUpDown.Location = new System.Drawing.Point(460, 156);
            this.authorPFPNumericUpDown.Maximum = new decimal(new int[] {
            255,
            0,
            0,
            0});
            this.authorPFPNumericUpDown.Name = "authorPFPNumericUpDown";
            this.authorPFPNumericUpDown.Size = new System.Drawing.Size(120, 20);
            this.authorPFPNumericUpDown.TabIndex = 27;
            this.authorPFPNumericUpDown.ValueChanged += new System.EventHandler(this.authorPFPNumericUpDown_ValueChanged);
            // 
            // authorNameTextBox
            // 
            this.authorNameTextBox.Location = new System.Drawing.Point(460, 74);
            this.authorNameTextBox.Multiline = true;
            this.authorNameTextBox.Name = "authorNameTextBox";
            this.authorNameTextBox.Size = new System.Drawing.Size(120, 63);
            this.authorNameTextBox.TabIndex = 26;
            this.authorNameTextBox.TextChanged += new System.EventHandler(this.authorNameTextBox_TextChanged);
            // 
            // bottomAuthorTextColorTextBox
            // 
            this.bottomAuthorTextColorTextBox.Location = new System.Drawing.Point(351, 221);
            this.bottomAuthorTextColorTextBox.MaxLength = 8;
            this.bottomAuthorTextColorTextBox.Name = "bottomAuthorTextColorTextBox";
            this.bottomAuthorTextColorTextBox.Size = new System.Drawing.Size(120, 20);
            this.bottomAuthorTextColorTextBox.TabIndex = 25;
            this.bottomAuthorTextColorTextBox.TextChanged += new System.EventHandler(this.bottomAuthorTextColorTextBox_TextChanged);
            this.bottomAuthorTextColorTextBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.colorTextBoxes_KeyPress);
            // 
            // topAuthorTextColorTextBox
            // 
            this.topAuthorTextColorTextBox.Location = new System.Drawing.Point(225, 221);
            this.topAuthorTextColorTextBox.MaxLength = 8;
            this.topAuthorTextColorTextBox.Name = "topAuthorTextColorTextBox";
            this.topAuthorTextColorTextBox.Size = new System.Drawing.Size(120, 20);
            this.topAuthorTextColorTextBox.TabIndex = 24;
            this.topAuthorTextColorTextBox.TextChanged += new System.EventHandler(this.topAuthorTextColorTextBox_TextChanged);
            this.topAuthorTextColorTextBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.colorTextBoxes_KeyPress);
            // 
            // authorQuoteRichTextBox
            // 
            this.authorQuoteRichTextBox.Location = new System.Drawing.Point(33, 74);
            this.authorQuoteRichTextBox.Name = "authorQuoteRichTextBox";
            this.authorQuoteRichTextBox.Size = new System.Drawing.Size(417, 63);
            this.authorQuoteRichTextBox.TabIndex = 23;
            this.authorQuoteRichTextBox.Text = "";
            this.authorQuoteRichTextBox.TextChanged += new System.EventHandler(this.authorQuoteRichTextBox_TextChanged);
            // 
            // authorQuoteLabel
            // 
            this.authorQuoteLabel.AutoSize = true;
            this.authorQuoteLabel.Location = new System.Drawing.Point(30, 58);
            this.authorQuoteLabel.Name = "authorQuoteLabel";
            this.authorQuoteLabel.Size = new System.Drawing.Size(78, 13);
            this.authorQuoteLabel.TabIndex = 22;
            this.authorQuoteLabel.Text = "Author\'s quote:";
            // 
            // Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 404);
            this.Controls.Add(this.propertiesGroupBox);
            this.Controls.Add(this.removePageButton);
            this.Controls.Add(this.addPageButton);
            this.Controls.Add(this.pageListBox);
            this.Controls.Add(this.bonusLevelsMenuStrip);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MainMenuStrip = this.bonusLevelsMenuStrip;
            this.MaximizeBox = false;
            this.Name = "Main";
            this.ShowIcon = false;
            this.Text = "Prankster Bonus Levels Editor";
            this.bonusLevelsMenuStrip.ResumeLayout(false);
            this.bonusLevelsMenuStrip.PerformLayout();
            this.propertiesGroupBox.ResumeLayout(false);
            this.propertiesGroupBox.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.levelFilenameLNumericUpDown)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.levelDisplayNameWNumericUpDown)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.levelDisplayNameLNumericUpDown)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.levelFilenameWNumericUpDown)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.authorPFPNumericUpDown)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox pageListBox;
        private System.Windows.Forms.Button addPageButton;
        private System.Windows.Forms.Button removePageButton;
        private System.Windows.Forms.MenuStrip bonusLevelsMenuStrip;
        private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem openToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveAsToolStripMenuItem;
        private System.Windows.Forms.GroupBox propertiesGroupBox;
        private System.Windows.Forms.Label levelDisplayNameLabel;
        private System.Windows.Forms.Label levelFilenameLabel;
        private System.Windows.Forms.Label bottomTXTColorLabel;
        private System.Windows.Forms.Label topTXTColorLabel;
        private System.Windows.Forms.Label authorPFPLabel;
        private System.Windows.Forms.Label authorNameLabel;
        private System.Windows.Forms.NumericUpDown levelFilenameLNumericUpDown;
        private System.Windows.Forms.NumericUpDown levelDisplayNameWNumericUpDown;
        private System.Windows.Forms.NumericUpDown levelDisplayNameLNumericUpDown;
        private System.Windows.Forms.NumericUpDown levelFilenameWNumericUpDown;
        private System.Windows.Forms.NumericUpDown authorPFPNumericUpDown;
        private System.Windows.Forms.TextBox authorNameTextBox;
        private System.Windows.Forms.TextBox bottomAuthorTextColorTextBox;
        private System.Windows.Forms.TextBox topAuthorTextColorTextBox;
        private System.Windows.Forms.RichTextBox authorQuoteRichTextBox;
        private System.Windows.Forms.Label authorQuoteLabel;
        private ToolStripSeparator toolStripSeparator1;
        private ToolStripMenuItem openOldToolStripMenuItem;
        private Label label1;
        private Label label2;
        private TextBox bottomLevelTextColorTextBox;
        private TextBox topLevelTextColorTextBox;
    }
}

