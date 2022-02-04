namespace rt_caiman
{
    partial class RTCImgProc
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
            this.picDisplay = new System.Windows.Forms.PictureBox();
            this.btnStartCapture = new System.Windows.Forms.Button();
            this.btnSaveImg = new System.Windows.Forms.Button();
            this.btnStartMCorre = new System.Windows.Forms.Button();
            this.textBoxROIr = new System.Windows.Forms.TextBox();
            this.textBoxROIc = new System.Windows.Forms.TextBox();
            this.btnSelectROI = new System.Windows.Forms.Button();
            this.checkBoxDisplayMC = new System.Windows.Forms.CheckBox();
            this.btnComputeTemplate = new System.Windows.Forms.Button();
            this.btnLoadContourConfig = new System.Windows.Forms.Button();
            this.groupBoxDisplayProj = new System.Windows.Forms.GroupBox();
            this.radioBtnMinProj = new System.Windows.Forms.RadioButton();
            this.radioBtnMeanProj = new System.Windows.Forms.RadioButton();
            this.radioBtnMaxProj = new System.Windows.Forms.RadioButton();
            this.checkBoxBypassTemp = new System.Windows.Forms.CheckBox();
            this.picTrace = new System.Windows.Forms.PictureBox();
            this.checkBoxDecode = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.picDisplay)).BeginInit();
            this.groupBoxDisplayProj.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.picTrace)).BeginInit();
            this.SuspendLayout();
            // 
            // picDisplay
            // 
            this.picDisplay.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.picDisplay.Location = new System.Drawing.Point(12, 13);
            this.picDisplay.Name = "picDisplay";
            this.picDisplay.Size = new System.Drawing.Size(512, 512);
            this.picDisplay.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picDisplay.TabIndex = 0;
            this.picDisplay.TabStop = false;
            this.picDisplay.Paint += new System.Windows.Forms.PaintEventHandler(this.picDisplay_Paint);
            this.picDisplay.MouseDown += new System.Windows.Forms.MouseEventHandler(this.picDisplay_MouseDown);
            this.picDisplay.MouseMove += new System.Windows.Forms.MouseEventHandler(this.picDisplay_MouseMove);
            // 
            // btnStartCapture
            // 
            this.btnStartCapture.Font = new System.Drawing.Font("Microsoft YaHei", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnStartCapture.Location = new System.Drawing.Point(249, 545);
            this.btnStartCapture.Name = "btnStartCapture";
            this.btnStartCapture.Size = new System.Drawing.Size(275, 27);
            this.btnStartCapture.TabIndex = 1;
            this.btnStartCapture.Text = "Capture Image for Building Template";
            this.btnStartCapture.UseVisualStyleBackColor = true;
            this.btnStartCapture.Click += new System.EventHandler(this.btnStartCapture_Click);
            // 
            // btnSaveImg
            // 
            this.btnSaveImg.Font = new System.Drawing.Font("Microsoft YaHei", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSaveImg.Location = new System.Drawing.Point(536, 578);
            this.btnSaveImg.Name = "btnSaveImg";
            this.btnSaveImg.Size = new System.Drawing.Size(196, 27);
            this.btnSaveImg.TabIndex = 2;
            this.btnSaveImg.Text = "Save Image";
            this.btnSaveImg.UseVisualStyleBackColor = true;
            this.btnSaveImg.Click += new System.EventHandler(this.btnSaveImg_Click);
            // 
            // btnStartMCorre
            // 
            this.btnStartMCorre.Font = new System.Drawing.Font("Microsoft YaHei", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnStartMCorre.Location = new System.Drawing.Point(536, 545);
            this.btnStartMCorre.Name = "btnStartMCorre";
            this.btnStartMCorre.Size = new System.Drawing.Size(196, 27);
            this.btnStartMCorre.TabIndex = 6;
            this.btnStartMCorre.Text = "Start Trace Extraction";
            this.btnStartMCorre.UseVisualStyleBackColor = true;
            this.btnStartMCorre.Click += new System.EventHandler(this.btnStartMCorre_Click);
            // 
            // textBoxROIr
            // 
            this.textBoxROIr.Location = new System.Drawing.Point(12, 583);
            this.textBoxROIr.Margin = new System.Windows.Forms.Padding(2);
            this.textBoxROIr.Name = "textBoxROIr";
            this.textBoxROIr.Size = new System.Drawing.Size(56, 20);
            this.textBoxROIr.TabIndex = 7;
            this.textBoxROIr.Text = "192";
            this.textBoxROIr.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textBoxROIr_KeyPress);
            // 
            // textBoxROIc
            // 
            this.textBoxROIc.Location = new System.Drawing.Point(76, 583);
            this.textBoxROIc.Margin = new System.Windows.Forms.Padding(2);
            this.textBoxROIc.Name = "textBoxROIc";
            this.textBoxROIc.Size = new System.Drawing.Size(56, 20);
            this.textBoxROIc.TabIndex = 8;
            this.textBoxROIc.Text = "192";
            this.textBoxROIc.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.textBoxROIc_KeyPress);
            // 
            // btnSelectROI
            // 
            this.btnSelectROI.Font = new System.Drawing.Font("Microsoft YaHei", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSelectROI.Location = new System.Drawing.Point(139, 578);
            this.btnSelectROI.Name = "btnSelectROI";
            this.btnSelectROI.Size = new System.Drawing.Size(104, 27);
            this.btnSelectROI.TabIndex = 9;
            this.btnSelectROI.Text = "Select ROI";
            this.btnSelectROI.UseVisualStyleBackColor = true;
            this.btnSelectROI.Click += new System.EventHandler(this.btnSelectROI_Click);
            // 
            // checkBoxDisplayMC
            // 
            this.checkBoxDisplayMC.AutoSize = true;
            this.checkBoxDisplayMC.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.checkBoxDisplayMC.Location = new System.Drawing.Point(757, 578);
            this.checkBoxDisplayMC.Margin = new System.Windows.Forms.Padding(2);
            this.checkBoxDisplayMC.Name = "checkBoxDisplayMC";
            this.checkBoxDisplayMC.Size = new System.Drawing.Size(163, 19);
            this.checkBoxDisplayMC.TabIndex = 12;
            this.checkBoxDisplayMC.Text = "Display Motion Corrected";
            this.checkBoxDisplayMC.UseVisualStyleBackColor = true;
            this.checkBoxDisplayMC.CheckedChanged += new System.EventHandler(this.checkBoxDisplayMC_CheckedChanged);
            // 
            // btnComputeTemplate
            // 
            this.btnComputeTemplate.Font = new System.Drawing.Font("Microsoft YaHei", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnComputeTemplate.Location = new System.Drawing.Point(249, 578);
            this.btnComputeTemplate.Name = "btnComputeTemplate";
            this.btnComputeTemplate.Size = new System.Drawing.Size(275, 27);
            this.btnComputeTemplate.TabIndex = 19;
            this.btnComputeTemplate.Text = "Compute Template";
            this.btnComputeTemplate.UseVisualStyleBackColor = true;
            this.btnComputeTemplate.Click += new System.EventHandler(this.btnComputeTemplate_Click);
            // 
            // btnLoadContourConfig
            // 
            this.btnLoadContourConfig.Font = new System.Drawing.Font("Microsoft YaHei", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnLoadContourConfig.Location = new System.Drawing.Point(12, 545);
            this.btnLoadContourConfig.Name = "btnLoadContourConfig";
            this.btnLoadContourConfig.Size = new System.Drawing.Size(231, 27);
            this.btnLoadContourConfig.TabIndex = 21;
            this.btnLoadContourConfig.Text = "Load Contour Configuration";
            this.btnLoadContourConfig.UseVisualStyleBackColor = true;
            this.btnLoadContourConfig.Click += new System.EventHandler(this.btnLoadContourConfig_Click);
            // 
            // groupBoxDisplayProj
            // 
            this.groupBoxDisplayProj.Controls.Add(this.radioBtnMinProj);
            this.groupBoxDisplayProj.Controls.Add(this.radioBtnMeanProj);
            this.groupBoxDisplayProj.Controls.Add(this.radioBtnMaxProj);
            this.groupBoxDisplayProj.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F);
            this.groupBoxDisplayProj.Location = new System.Drawing.Point(12, 463);
            this.groupBoxDisplayProj.Name = "groupBoxDisplayProj";
            this.groupBoxDisplayProj.Size = new System.Drawing.Size(420, 29);
            this.groupBoxDisplayProj.TabIndex = 35;
            this.groupBoxDisplayProj.TabStop = false;
            this.groupBoxDisplayProj.Text = "Display Projection";
            // 
            // radioBtnMinProj
            // 
            this.radioBtnMinProj.Location = new System.Drawing.Point(0, 0);
            this.radioBtnMinProj.Name = "radioBtnMinProj";
            this.radioBtnMinProj.Size = new System.Drawing.Size(104, 24);
            this.radioBtnMinProj.TabIndex = 0;
            // 
            // radioBtnMeanProj
            // 
            this.radioBtnMeanProj.Location = new System.Drawing.Point(0, 0);
            this.radioBtnMeanProj.Name = "radioBtnMeanProj";
            this.radioBtnMeanProj.Size = new System.Drawing.Size(104, 24);
            this.radioBtnMeanProj.TabIndex = 1;
            // 
            // radioBtnMaxProj
            // 
            this.radioBtnMaxProj.Location = new System.Drawing.Point(0, 0);
            this.radioBtnMaxProj.Name = "radioBtnMaxProj";
            this.radioBtnMaxProj.Size = new System.Drawing.Size(104, 24);
            this.radioBtnMaxProj.TabIndex = 2;
            // 
            // checkBoxBypassTemp
            // 
            this.checkBoxBypassTemp.AutoSize = true;
            this.checkBoxBypassTemp.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.checkBoxBypassTemp.Location = new System.Drawing.Point(757, 553);
            this.checkBoxBypassTemp.Margin = new System.Windows.Forms.Padding(2);
            this.checkBoxBypassTemp.Name = "checkBoxBypassTemp";
            this.checkBoxBypassTemp.Size = new System.Drawing.Size(163, 19);
            this.checkBoxBypassTemp.TabIndex = 37;
            this.checkBoxBypassTemp.Text = "Bypass Template Update";
            this.checkBoxBypassTemp.UseVisualStyleBackColor = true;
            this.checkBoxBypassTemp.CheckedChanged += new System.EventHandler(this.checkBoxBypassTemp_CheckedChanged);
            // 
            // picTrace
            // 
            this.picTrace.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.picTrace.Location = new System.Drawing.Point(536, 13);
            this.picTrace.Name = "picTrace";
            this.picTrace.Size = new System.Drawing.Size(400, 512);
            this.picTrace.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picTrace.TabIndex = 38;
            this.picTrace.TabStop = false;
            // 
            // checkBoxDecode
            // 
            this.checkBoxDecode.Location = new System.Drawing.Point(0, 0);
            this.checkBoxDecode.Name = "checkBoxDecode";
            this.checkBoxDecode.Size = new System.Drawing.Size(104, 24);
            this.checkBoxDecode.TabIndex = 0;
            // 
            // RTCImgProc
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.ClientSize = new System.Drawing.Size(948, 621);
            this.Controls.Add(this.checkBoxDecode);
            this.Controls.Add(this.picTrace);
            this.Controls.Add(this.checkBoxBypassTemp);
            this.Controls.Add(this.btnLoadContourConfig);
            this.Controls.Add(this.btnComputeTemplate);
            this.Controls.Add(this.checkBoxDisplayMC);
            this.Controls.Add(this.btnSelectROI);
            this.Controls.Add(this.textBoxROIc);
            this.Controls.Add(this.textBoxROIr);
            this.Controls.Add(this.btnStartMCorre);
            this.Controls.Add(this.btnSaveImg);
            this.Controls.Add(this.btnStartCapture);
            this.Controls.Add(this.picDisplay);
            this.Controls.Add(this.groupBoxDisplayProj);
            this.Name = "RTCImgProc";
            this.Text = "RTCImgProc Terminal";
            ((System.ComponentModel.ISupportInitialize)(this.picDisplay)).EndInit();
            this.groupBoxDisplayProj.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.picTrace)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox picDisplay;
        private System.Windows.Forms.Button btnStartCapture;
        private System.Windows.Forms.Button btnSaveImg;
        private System.Windows.Forms.Button btnStartMCorre;
        private System.Windows.Forms.TextBox textBoxROIr;
        private System.Windows.Forms.TextBox textBoxROIc;
        private System.Windows.Forms.Button btnSelectROI;
        private System.Windows.Forms.CheckBox checkBoxDisplayMC;
        private System.Windows.Forms.Button btnComputeTemplate;
        private System.Windows.Forms.Button btnLoadContourConfig;
        private System.Windows.Forms.GroupBox groupBoxDisplayProj;
        private System.Windows.Forms.RadioButton radioBtnMinProj;
        private System.Windows.Forms.RadioButton radioBtnMeanProj;
        private System.Windows.Forms.RadioButton radioBtnMaxProj;
        private System.Windows.Forms.CheckBox checkBoxBypassTemp;
        private System.Windows.Forms.PictureBox picTrace;
        private System.Windows.Forms.CheckBox checkBoxDecode;
    }
}

