namespace PranksterToolbox.StaffCreditsEditor
{
    partial class Main
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.pageListBox = new System.Windows.Forms.ListBox();
            this.staffCreditsMenuStrip = new System.Windows.Forms.MenuStrip();
            this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.openToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveAsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.removePageButton = new System.Windows.Forms.Button();
            this.addPageButton = new System.Windows.Forms.Button();
            this.titleTextBox1 = new System.Windows.Forms.TextBox();
            this.titleLabel1 = new System.Windows.Forms.Label();
            this.titleLabel2 = new System.Windows.Forms.Label();
            this.contentTextBox1 = new System.Windows.Forms.TextBox();
            this.contentLabel1 = new System.Windows.Forms.Label();
            this.contentLabel2 = new System.Windows.Forms.Label();
            this.contentTextBox2 = new System.Windows.Forms.TextBox();
            this.titleTextBox2 = new System.Windows.Forms.TextBox();
            this.validateButton = new System.Windows.Forms.Button();
            this.durationNumUpDown = new System.Windows.Forms.NumericUpDown();
            this.framesLabel = new System.Windows.Forms.Label();
            this.propertiesGroupBox = new System.Windows.Forms.GroupBox();
            this.staffCreditsMenuStrip.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.durationNumUpDown)).BeginInit();
            this.propertiesGroupBox.SuspendLayout();
            this.SuspendLayout();
            // 
            // pageListBox
            // 
            this.pageListBox.FormattingEnabled = true;
            this.pageListBox.Location = new System.Drawing.Point(12, 38);
            this.pageListBox.Name = "pageListBox";
            this.pageListBox.Size = new System.Drawing.Size(156, 368);
            this.pageListBox.TabIndex = 0;
            this.pageListBox.SelectedIndexChanged += new System.EventHandler(this.pageListBox_SelectedIndexChanged);
            // 
            // staffCreditsMenuStrip
            // 
            this.staffCreditsMenuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileToolStripMenuItem});
            this.staffCreditsMenuStrip.Location = new System.Drawing.Point(0, 0);
            this.staffCreditsMenuStrip.Name = "staffCreditsMenuStrip";
            this.staffCreditsMenuStrip.Size = new System.Drawing.Size(562, 24);
            this.staffCreditsMenuStrip.TabIndex = 1;
            this.staffCreditsMenuStrip.Text = "staffCreditsMenuStrip";
            // 
            // fileToolStripMenuItem
            // 
            this.fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.openToolStripMenuItem,
            this.saveToolStripMenuItem,
            this.saveAsToolStripMenuItem});
            this.fileToolStripMenuItem.Name = "fileToolStripMenuItem";
            this.fileToolStripMenuItem.Size = new System.Drawing.Size(37, 20);
            this.fileToolStripMenuItem.Text = "File";
            // 
            // openToolStripMenuItem
            // 
            this.openToolStripMenuItem.Name = "openToolStripMenuItem";
            this.openToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.O)));
            this.openToolStripMenuItem.Size = new System.Drawing.Size(191, 22);
            this.openToolStripMenuItem.Text = "Open...";
            this.openToolStripMenuItem.Click += new System.EventHandler(this.openToolStripMenuItem_Click);
            // 
            // saveToolStripMenuItem
            // 
            this.saveToolStripMenuItem.Enabled = false;
            this.saveToolStripMenuItem.Name = "saveToolStripMenuItem";
            this.saveToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.S)));
            this.saveToolStripMenuItem.Size = new System.Drawing.Size(191, 22);
            this.saveToolStripMenuItem.Text = "Save";
            this.saveToolStripMenuItem.Click += new System.EventHandler(this.saveToolStripMenuItem_Click);
            // 
            // saveAsToolStripMenuItem
            // 
            this.saveAsToolStripMenuItem.Enabled = false;
            this.saveAsToolStripMenuItem.Name = "saveAsToolStripMenuItem";
            this.saveAsToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)(((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Shift) 
            | System.Windows.Forms.Keys.S)));
            this.saveAsToolStripMenuItem.Size = new System.Drawing.Size(191, 22);
            this.saveAsToolStripMenuItem.Text = "Save As...";
            this.saveAsToolStripMenuItem.Click += new System.EventHandler(this.saveAsToolStripMenuItem_Click);
            // 
            // removePageButton
            // 
            this.removePageButton.Location = new System.Drawing.Point(93, 420);
            this.removePageButton.Name = "removePageButton";
            this.removePageButton.Size = new System.Drawing.Size(75, 23);
            this.removePageButton.TabIndex = 4;
            this.removePageButton.Text = "Remove";
            this.removePageButton.UseVisualStyleBackColor = true;
            this.removePageButton.Click += new System.EventHandler(this.removePageButton_Click);
            // 
            // addPageButton
            // 
            this.addPageButton.Location = new System.Drawing.Point(12, 420);
            this.addPageButton.Name = "addPageButton";
            this.addPageButton.Size = new System.Drawing.Size(75, 23);
            this.addPageButton.TabIndex = 3;
            this.addPageButton.Text = "Add";
            this.addPageButton.UseVisualStyleBackColor = true;
            this.addPageButton.Click += new System.EventHandler(this.addPageButton_Click);
            // 
            // titleTextBox1
            // 
            this.titleTextBox1.Location = new System.Drawing.Point(110, 19);
            this.titleTextBox1.Name = "titleTextBox1";
            this.titleTextBox1.Size = new System.Drawing.Size(204, 20);
            this.titleTextBox1.TabIndex = 5;
            this.titleTextBox1.TextChanged += new System.EventHandler(this.pageProperty_Changed);
            // 
            // titleLabel1
            // 
            this.titleLabel1.AutoSize = true;
            this.titleLabel1.Location = new System.Drawing.Point(74, 22);
            this.titleLabel1.Name = "titleLabel1";
            this.titleLabel1.Size = new System.Drawing.Size(30, 13);
            this.titleLabel1.TabIndex = 6;
            this.titleLabel1.Text = "Title:";
            // 
            // titleLabel2
            // 
            this.titleLabel2.AutoSize = true;
            this.titleLabel2.Location = new System.Drawing.Point(74, 174);
            this.titleLabel2.Name = "titleLabel2";
            this.titleLabel2.Size = new System.Drawing.Size(30, 13);
            this.titleLabel2.TabIndex = 7;
            this.titleLabel2.Text = "Title:";
            // 
            // contentTextBox1
            // 
            this.contentTextBox1.Location = new System.Drawing.Point(110, 45);
            this.contentTextBox1.Multiline = true;
            this.contentTextBox1.Name = "contentTextBox1";
            this.contentTextBox1.Size = new System.Drawing.Size(204, 120);
            this.contentTextBox1.TabIndex = 8;
            this.contentTextBox1.TextChanged += new System.EventHandler(this.pageProperty_Changed);
            // 
            // contentLabel1
            // 
            this.contentLabel1.AutoSize = true;
            this.contentLabel1.Location = new System.Drawing.Point(57, 48);
            this.contentLabel1.Name = "contentLabel1";
            this.contentLabel1.Size = new System.Drawing.Size(47, 13);
            this.contentLabel1.TabIndex = 9;
            this.contentLabel1.Text = "Content:";
            // 
            // contentLabel2
            // 
            this.contentLabel2.AutoSize = true;
            this.contentLabel2.Location = new System.Drawing.Point(57, 200);
            this.contentLabel2.Name = "contentLabel2";
            this.contentLabel2.Size = new System.Drawing.Size(47, 13);
            this.contentLabel2.TabIndex = 13;
            this.contentLabel2.Text = "Content:";
            // 
            // contentTextBox2
            // 
            this.contentTextBox2.Location = new System.Drawing.Point(110, 197);
            this.contentTextBox2.Multiline = true;
            this.contentTextBox2.Name = "contentTextBox2";
            this.contentTextBox2.Size = new System.Drawing.Size(204, 120);
            this.contentTextBox2.TabIndex = 12;
            this.contentTextBox2.TextChanged += new System.EventHandler(this.pageProperty_Changed);
            // 
            // titleTextBox2
            // 
            this.titleTextBox2.Location = new System.Drawing.Point(110, 171);
            this.titleTextBox2.Name = "titleTextBox2";
            this.titleTextBox2.Size = new System.Drawing.Size(204, 20);
            this.titleTextBox2.TabIndex = 10;
            this.titleTextBox2.TextChanged += new System.EventHandler(this.pageProperty_Changed);
            // 
            // validateButton
            // 
            this.validateButton.Enabled = false;
            this.validateButton.Location = new System.Drawing.Point(128, 363);
            this.validateButton.Name = "validateButton";
            this.validateButton.Size = new System.Drawing.Size(75, 23);
            this.validateButton.TabIndex = 14;
            this.validateButton.Text = "Validate";
            this.validateButton.UseVisualStyleBackColor = true;
            this.validateButton.Click += new System.EventHandler(this.validateButton_Click);
            // 
            // durationNumUpDown
            // 
            this.durationNumUpDown.Location = new System.Drawing.Point(110, 323);
            this.durationNumUpDown.Maximum = new decimal(new int[] {
            65535,
            0,
            0,
            0});
            this.durationNumUpDown.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.durationNumUpDown.Name = "durationNumUpDown";
            this.durationNumUpDown.Size = new System.Drawing.Size(204, 20);
            this.durationNumUpDown.TabIndex = 15;
            this.durationNumUpDown.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.durationNumUpDown.ValueChanged += new System.EventHandler(this.pageProperty_Changed);
            // 
            // framesLabel
            // 
            this.framesLabel.AutoSize = true;
            this.framesLabel.Location = new System.Drawing.Point(14, 325);
            this.framesLabel.Name = "framesLabel";
            this.framesLabel.Size = new System.Drawing.Size(90, 13);
            this.framesLabel.TabIndex = 16;
            this.framesLabel.Text = "Duration (frames):";
            // 
            // propertiesGroupBox
            // 
            this.propertiesGroupBox.Controls.Add(this.framesLabel);
            this.propertiesGroupBox.Controls.Add(this.titleTextBox1);
            this.propertiesGroupBox.Controls.Add(this.durationNumUpDown);
            this.propertiesGroupBox.Controls.Add(this.titleLabel1);
            this.propertiesGroupBox.Controls.Add(this.validateButton);
            this.propertiesGroupBox.Controls.Add(this.titleLabel2);
            this.propertiesGroupBox.Controls.Add(this.contentLabel2);
            this.propertiesGroupBox.Controls.Add(this.contentTextBox1);
            this.propertiesGroupBox.Controls.Add(this.contentTextBox2);
            this.propertiesGroupBox.Controls.Add(this.contentLabel1);
            this.propertiesGroupBox.Controls.Add(this.titleTextBox2);
            this.propertiesGroupBox.Enabled = false;
            this.propertiesGroupBox.Location = new System.Drawing.Point(200, 38);
            this.propertiesGroupBox.Name = "propertiesGroupBox";
            this.propertiesGroupBox.Size = new System.Drawing.Size(329, 405);
            this.propertiesGroupBox.TabIndex = 17;
            this.propertiesGroupBox.TabStop = false;
            this.propertiesGroupBox.Text = "Properties";
            // 
            // Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(562, 455);
            this.Controls.Add(this.propertiesGroupBox);
            this.Controls.Add(this.removePageButton);
            this.Controls.Add(this.addPageButton);
            this.Controls.Add(this.pageListBox);
            this.Controls.Add(this.staffCreditsMenuStrip);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MainMenuStrip = this.staffCreditsMenuStrip;
            this.MaximizeBox = false;
            this.Name = "Main";
            this.ShowIcon = false;
            this.Text = "Prankster Staff Credits Editor";
            this.staffCreditsMenuStrip.ResumeLayout(false);
            this.staffCreditsMenuStrip.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.durationNumUpDown)).EndInit();
            this.propertiesGroupBox.ResumeLayout(false);
            this.propertiesGroupBox.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox pageListBox;
        private System.Windows.Forms.MenuStrip staffCreditsMenuStrip;
        private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem openToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveAsToolStripMenuItem;
        private System.Windows.Forms.Button removePageButton;
        private System.Windows.Forms.Button addPageButton;
        private System.Windows.Forms.TextBox titleTextBox1;
        private System.Windows.Forms.Label titleLabel1;
        private System.Windows.Forms.Label titleLabel2;
        private System.Windows.Forms.TextBox contentTextBox1;
        private System.Windows.Forms.Label contentLabel1;
        private System.Windows.Forms.Label contentLabel2;
        private System.Windows.Forms.TextBox contentTextBox2;
        private System.Windows.Forms.TextBox titleTextBox2;
        private System.Windows.Forms.Button validateButton;
        private System.Windows.Forms.NumericUpDown durationNumUpDown;
        private System.Windows.Forms.Label framesLabel;
        private System.Windows.Forms.GroupBox propertiesGroupBox;
    }
}