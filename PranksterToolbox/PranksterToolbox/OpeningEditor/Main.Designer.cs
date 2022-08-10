namespace PranksterToolbox.OpeningEditor
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
            this.pageTextRichTextBox = new System.Windows.Forms.RichTextBox();
            this.pageTextLabel = new System.Windows.Forms.Label();
            this.openingMenuStrip = new System.Windows.Forms.MenuStrip();
            this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.openToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveAsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.openOldToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.musicNUD = new System.Windows.Forms.NumericUpDown();
            this.sfxNUD = new System.Windows.Forms.NumericUpDown();
            this.musicLabel = new System.Windows.Forms.Label();
            this.sfxLabel = new System.Windows.Forms.Label();
            this.openingMenuStrip.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.musicNUD)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.sfxNUD)).BeginInit();
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
            // addPageButton
            // 
            this.addPageButton.Location = new System.Drawing.Point(12, 420);
            this.addPageButton.Name = "addPageButton";
            this.addPageButton.Size = new System.Drawing.Size(75, 23);
            this.addPageButton.TabIndex = 1;
            this.addPageButton.Text = "Add";
            this.addPageButton.UseVisualStyleBackColor = true;
            this.addPageButton.Click += new System.EventHandler(this.addPageButton_Click);
            // 
            // removePageButton
            // 
            this.removePageButton.Location = new System.Drawing.Point(93, 420);
            this.removePageButton.Name = "removePageButton";
            this.removePageButton.Size = new System.Drawing.Size(75, 23);
            this.removePageButton.TabIndex = 2;
            this.removePageButton.Text = "Remove";
            this.removePageButton.UseVisualStyleBackColor = true;
            this.removePageButton.Click += new System.EventHandler(this.removePageButton_Click);
            // 
            // pageTextRichTextBox
            // 
            this.pageTextRichTextBox.Enabled = false;
            this.pageTextRichTextBox.Location = new System.Drawing.Point(285, 114);
            this.pageTextRichTextBox.Name = "pageTextRichTextBox";
            this.pageTextRichTextBox.Size = new System.Drawing.Size(408, 96);
            this.pageTextRichTextBox.TabIndex = 3;
            this.pageTextRichTextBox.Text = "";
            this.pageTextRichTextBox.TextChanged += new System.EventHandler(this.pageTextRichTextBox_TextChanged);
            // 
            // pageTextLabel
            // 
            this.pageTextLabel.AutoSize = true;
            this.pageTextLabel.Location = new System.Drawing.Point(282, 98);
            this.pageTextLabel.Name = "pageTextLabel";
            this.pageTextLabel.Size = new System.Drawing.Size(59, 13);
            this.pageTextLabel.TabIndex = 4;
            this.pageTextLabel.Text = "Page Text:";
            // 
            // openingMenuStrip
            // 
            this.openingMenuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileToolStripMenuItem});
            this.openingMenuStrip.Location = new System.Drawing.Point(0, 0);
            this.openingMenuStrip.Name = "openingMenuStrip";
            this.openingMenuStrip.Size = new System.Drawing.Size(800, 24);
            this.openingMenuStrip.TabIndex = 5;
            this.openingMenuStrip.Text = "openingMenuStrip";
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
            this.openToolStripMenuItem.Size = new System.Drawing.Size(191, 22);
            this.openToolStripMenuItem.Text = "Open...";
            this.openToolStripMenuItem.Click += new System.EventHandler(this.openToolStripMenuItem_Click);
            // 
            // saveToolStripMenuItem
            // 
            this.saveToolStripMenuItem.Name = "saveToolStripMenuItem";
            this.saveToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.S)));
            this.saveToolStripMenuItem.Size = new System.Drawing.Size(191, 22);
            this.saveToolStripMenuItem.Text = "Save";
            this.saveToolStripMenuItem.Click += new System.EventHandler(this.saveToolStripMenuItem_Click);
            // 
            // saveAsToolStripMenuItem
            // 
            this.saveAsToolStripMenuItem.Name = "saveAsToolStripMenuItem";
            this.saveAsToolStripMenuItem.ShortcutKeys = ((System.Windows.Forms.Keys)(((System.Windows.Forms.Keys.Control | System.Windows.Forms.Keys.Shift) 
            | System.Windows.Forms.Keys.S)));
            this.saveAsToolStripMenuItem.Size = new System.Drawing.Size(191, 22);
            this.saveAsToolStripMenuItem.Text = "Save As...";
            this.saveAsToolStripMenuItem.Click += new System.EventHandler(this.saveAsToolStripMenuItem_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(188, 6);
            this.toolStripSeparator1.Visible = false;
            // 
            // openOldToolStripMenuItem
            // 
            this.openOldToolStripMenuItem.Name = "openOldToolStripMenuItem";
            this.openOldToolStripMenuItem.Size = new System.Drawing.Size(191, 22);
            this.openOldToolStripMenuItem.Text = "Open Old...";
            this.openOldToolStripMenuItem.Visible = false;
            this.openOldToolStripMenuItem.Click += new System.EventHandler(this.openOldToolStripMenuItem_Click);
            // 
            // musicNUD
            // 
            this.musicNUD.Location = new System.Drawing.Point(340, 244);
            this.musicNUD.Maximum = new decimal(new int[] {
            65535,
            0,
            0,
            0});
            this.musicNUD.Name = "musicNUD";
            this.musicNUD.Size = new System.Drawing.Size(120, 20);
            this.musicNUD.TabIndex = 6;
            this.musicNUD.ValueChanged += new System.EventHandler(this.musicNUD_ValueChanged);
            // 
            // sfxNUD
            // 
            this.sfxNUD.Location = new System.Drawing.Point(573, 244);
            this.sfxNUD.Maximum = new decimal(new int[] {
            65535,
            0,
            0,
            0});
            this.sfxNUD.Name = "sfxNUD";
            this.sfxNUD.Size = new System.Drawing.Size(120, 20);
            this.sfxNUD.TabIndex = 7;
            this.sfxNUD.ValueChanged += new System.EventHandler(this.sfxNUD_ValueChanged);
            // 
            // musicLabel
            // 
            this.musicLabel.AutoSize = true;
            this.musicLabel.Location = new System.Drawing.Point(282, 248);
            this.musicLabel.Name = "musicLabel";
            this.musicLabel.Size = new System.Drawing.Size(52, 13);
            this.musicLabel.TabIndex = 8;
            this.musicLabel.Text = "Music ID:";
            // 
            // sfxLabel
            // 
            this.sfxLabel.AutoSize = true;
            this.sfxLabel.Location = new System.Drawing.Point(523, 248);
            this.sfxLabel.Name = "sfxLabel";
            this.sfxLabel.Size = new System.Drawing.Size(44, 13);
            this.sfxLabel.TabIndex = 9;
            this.sfxLabel.Text = "SFX ID:";
            // 
            // Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 455);
            this.Controls.Add(this.sfxLabel);
            this.Controls.Add(this.musicLabel);
            this.Controls.Add(this.sfxNUD);
            this.Controls.Add(this.musicNUD);
            this.Controls.Add(this.pageTextLabel);
            this.Controls.Add(this.pageTextRichTextBox);
            this.Controls.Add(this.removePageButton);
            this.Controls.Add(this.addPageButton);
            this.Controls.Add(this.pageListBox);
            this.Controls.Add(this.openingMenuStrip);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MainMenuStrip = this.openingMenuStrip;
            this.MaximizeBox = false;
            this.Name = "Main";
            this.ShowIcon = false;
            this.Text = "Prankster Opening Editor";
            this.openingMenuStrip.ResumeLayout(false);
            this.openingMenuStrip.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.musicNUD)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.sfxNUD)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListBox pageListBox;
        private System.Windows.Forms.Button addPageButton;
        private System.Windows.Forms.Button removePageButton;
        private System.Windows.Forms.RichTextBox pageTextRichTextBox;
        private System.Windows.Forms.Label pageTextLabel;
        private System.Windows.Forms.MenuStrip openingMenuStrip;
        private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem openToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveAsToolStripMenuItem;
        private System.Windows.Forms.NumericUpDown musicNUD;
        private System.Windows.Forms.NumericUpDown sfxNUD;
        private System.Windows.Forms.Label musicLabel;
        private System.Windows.Forms.Label sfxLabel;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripMenuItem openOldToolStripMenuItem;
    }
}

