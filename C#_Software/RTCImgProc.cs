using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;
using System.Net;
using System.Net.Sockets;
using System.IO;
using System.Numerics;

namespace rt_caiman
{
    public partial class RTCImgProc : Form
    {
        public static Socket TCPsocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

        public static int ImgW = 512;
        public static int ImgH = 512;
        public static int ImgSize = ImgW * ImgH;
        public static int dispImgW = ImgW;
        public static int dispImgH = ImgH;
        public static int dispImgSize = dispImgW * dispImgH;
        public static byte[] dispImg = new byte[dispImgSize];
        public static byte[] dispRGBImg = new byte[dispImgSize * 3];
        public static int dispTraceW = 400;
        public static int dispTraceH = 512;
        public static int dispTraceSize = dispTraceW * dispTraceH;
        public static byte[] dispTrace = new byte[dispTraceSize];
        public static byte[] dispRGBTrace = new byte[dispTraceSize * 3];
        public static int SUB_H = 128;
        public static int SUB_W = 128;
        public static string work_path = AppDomain.CurrentDomain.BaseDirectory;
        public static int loc = work_path.IndexOf("bin\\Debug");

        private Rectangle RcDraw;
        private float PenWidth = 3;
        public static int selectROIstate = 0;
        public static int selectModeIsOffline = 0;

        public static int bypassTemplate = 0;
        public static int displayMode = 0;
        public static int recordingIsOn = 0;

        public static int tickcnt = 0;

        //Used in btnLoadContourConfig_Click function.
        public static int cellNum = 1024;
        //creates buffer arrays for (1) location info, (2) normalization factors, and (3) contour maps. 
        public static Point[] cellLoc = new Point[cellNum];
        public static Point[] normFactors = new Point[cellNum];
        public static int[,,] contourMaps = new int[cellNum, 25, 25];

        public static byte[] maxProjImg = new byte[dispImgSize];
        public static byte[] meanProjImg = new byte[dispImgSize];
        public static byte[] minProjImg = new byte[dispImgSize];
        public static byte[] maskArray = new byte[dispImgSize * 3];

        public static bool allowstaticContourToggle = false;
        public static bool btnLoadContourConfigClickedBefore = false;
        public static bool contourToggleClickedBefore = false;

        public static int[,] MaxMin = new int[cellNum, 2];

        public static int[,] Tid = new int[12, 63];
        public static int[,] Max = new int[12, 63];
        public static int[,] Min = new int[12, 63];

        public static int cur_group = 11;

        public static byte[] color = new byte[7 * 3];

        public RTCImgProc()
        {
            InitializeComponent();

            // Set up Matlab plot colors.
            color[0 * 3 + 0] = (byte)(0.7410 * 255); // blue
            color[0 * 3 + 1] = (byte)(0.4470 * 255); // green
            color[0 * 3 + 2] = (byte)(0.0000 * 255); // red

            color[1 * 3 + 0] = (byte)(0.0980 * 255);
            color[1 * 3 + 1] = (byte)(0.3250 * 255);
            color[1 * 3 + 2] = (byte)(0.8500 * 255);

            color[2 * 3 + 0] = (byte)(0.1250 * 255);
            color[2 * 3 + 1] = (byte)(0.6940 * 255);
            color[2 * 3 + 2] = (byte)(0.9290 * 255);

            color[3 * 3 + 0] = (byte)(0.5560 * 255);
            color[3 * 3 + 1] = (byte)(0.1840 * 255);
            color[3 * 3 + 2] = (byte)(0.4940 * 255);

            color[4 * 3 + 0] = (byte)(0.1880 * 255);
            color[4 * 3 + 1] = (byte)(0.6740 * 255);
            color[4 * 3 + 2] = (byte)(0.4660 * 255);

            color[5 * 3 + 0] = (byte)(0.9330 * 255);
            color[5 * 3 + 1] = (byte)(0.7450 * 255);
            color[5 * 3 + 2] = (byte)(0.3010 * 255);

            color[6 * 3 + 0] = (byte)(0.1840 * 255);
            color[6 * 3 + 1] = (byte)(0.0780 * 255);
            color[6 * 3 + 2] = (byte)(0.6350 * 255);
        }

        public static void StartClient()
        {
            try
            {
                IPAddress ipAddress = IPAddress.Parse("192.168.1.10");
                IPEndPoint remoteEP = new IPEndPoint(ipAddress, 5001);

                // Connect the socket to the remote endpoint. Catch any errors.
                try
                {
                    TCPsocket.Connect(remoteEP);
                }
                catch (ArgumentNullException ane)
                {
                    Console.WriteLine("ArgumentNullException: {0}", ane.ToString());
                }
                catch (SocketException se)
                {
                    Console.WriteLine("SocketException: {0}", se.ToString());
                }
                catch (Exception e)
                {
                    Console.WriteLine("Unexpected exception: {0}", e.ToString());
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }
        }

        public static void Send(Socket socket, byte[] buffer, int offset, int size, int timeout)
        {
            int startTickCount = Environment.TickCount;
            int sent = 0;  // how many bytes is already sent
            do
            {
                if (Environment.TickCount > startTickCount + timeout)
                    throw new Exception("Timeout.");
                try
                {
                    sent += socket.Send(buffer, offset + sent, size - sent, SocketFlags.None);
                }
                catch (SocketException ex)
                {
                    if (ex.SocketErrorCode == SocketError.WouldBlock ||
                        ex.SocketErrorCode == SocketError.IOPending ||
                        ex.SocketErrorCode == SocketError.NoBufferSpaceAvailable)
                    {
                        // socket buffer is probably full, wait and try again
                        //Thread.Sleep(10);
                    }
                    else
                    {
                        throw ex;
                    }
                }
            }
            while (sent < size);
        }

        public static void Receive(Socket socket, byte[] buffer, int offset, int size, int timeout)
        {
            int startTickCount = Environment.TickCount;
            int received = 0;  // how many bytes is already received
            do
            {
                if (Environment.TickCount > startTickCount + timeout)
                    throw new Exception("Timeout.");
                try
                {
                    received += socket.Receive(buffer, offset + received, size - received, SocketFlags.None);
                }
                catch (SocketException ex)
                {
                    if (ex.SocketErrorCode == SocketError.WouldBlock ||
                        ex.SocketErrorCode == SocketError.IOPending ||
                        ex.SocketErrorCode == SocketError.NoBufferSpaceAvailable)
                    {
                        // socket buffer is probably empty, wait and try again
                        Console.WriteLine("entered");
                        //Thread.Sleep(10);
                    }
                    else
                    {
                        throw ex;
                    }
                }
            }
            while (received < size);
        }

        // Delegates to enable async calls for setting controls properties
        private delegate void SetImageCallback(Bitmap bmp);

        private void SetImage(Bitmap image)
        {
            if (this.picDisplay.InvokeRequired)
            {
                SetImageCallback callback = new SetImageCallback(SetImage);
                this.BeginInvoke(callback, new object[] { image });
            }
            else
            {
                picDisplay.Image = image;
            }
        }

        private void SetTrace(Bitmap image)
        {
            if (this.picTrace.InvokeRequired)
            {
                SetImageCallback callback = new SetImageCallback(SetTrace);
                this.BeginInvoke(callback, new object[] { image });
            }
            else
            {
                picTrace.Image = image;
            }
        }

        public void displayImage(byte[] dispImg)
        {
            int i;

            // Create a new Bitmap
            Bitmap bmp = new Bitmap(dispImgW, dispImgH, System.Drawing.Imaging.PixelFormat.Format8bppIndexed);

            // Create grayscale palette
            System.Drawing.Imaging.ColorPalette pal = bmp.Palette;
            for (i = 0; i < 256; ++i)
            {
                pal.Entries[i] = Color.FromArgb((int)255, i, i, i);
            }
            bmp.Palette = pal;

            // Lock it to get the BitmapData Object
            System.Drawing.Imaging.BitmapData bmData = 
                bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), System.Drawing.Imaging.ImageLockMode.WriteOnly,
                System.Drawing.Imaging.PixelFormat.Format8bppIndexed);

            // Copy the bytes
            System.Runtime.InteropServices.Marshal.Copy(dispImg, 0, bmData.Scan0, bmData.Stride * bmData.Height);

            // Never forget to unlock the bitmap
            bmp.UnlockBits(bmData);

            //picDisplay.Image = bmp;
            SetImage(bmp);
        }

        public void displayTrace(byte[] dispTrace)
        {
            int i;

            // Create a new Bitmap
            Bitmap bmp = new Bitmap(dispTraceW, dispTraceH, System.Drawing.Imaging.PixelFormat.Format8bppIndexed);

            // Create grayscale palette
            System.Drawing.Imaging.ColorPalette pal = bmp.Palette;
            for (i = 0; i < 256; ++i)
            {
                pal.Entries[i] = Color.FromArgb((int)255, i, i, i);
            }
            bmp.Palette = pal;

            // Lock it to get the BitmapData Object
            System.Drawing.Imaging.BitmapData bmData =
                bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), System.Drawing.Imaging.ImageLockMode.WriteOnly,
                System.Drawing.Imaging.PixelFormat.Format8bppIndexed);

            // Copy the bytes
            System.Runtime.InteropServices.Marshal.Copy(dispTrace, 0, bmData.Scan0, bmData.Stride * bmData.Height);

            // Never forget to unlock the bitmap
            bmp.UnlockBits(bmData);

            //picTrace.Image = bmp;
            SetTrace(bmp);
        }

        public void displayRGBTrace(byte[] dispImg)
        {
            // Create a new Bitmap
            Bitmap bmp = new Bitmap(dispTraceW, dispTraceH, System.Drawing.Imaging.PixelFormat.Format24bppRgb);

            // Lock it to get the BitmapData Object
            System.Drawing.Imaging.BitmapData bmData =
                bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), System.Drawing.Imaging.ImageLockMode.WriteOnly,
                System.Drawing.Imaging.PixelFormat.Format24bppRgb);


            // Copy the bytes
            System.Runtime.InteropServices.Marshal.Copy(dispImg, 0, bmData.Scan0, bmData.Stride * bmData.Height);

            // Never forget to unlock the bitmap
            bmp.UnlockBits(bmData);

            //picTrace.Image = bmp;
            SetTrace(bmp);
        }

        public void displayRGBImage(byte[] dispImg)
        {
            // Create a new Bitmap
            Bitmap bmp = new Bitmap(dispImgW, dispImgH, System.Drawing.Imaging.PixelFormat.Format24bppRgb);

            // Lock it to get the BitmapData Object
            System.Drawing.Imaging.BitmapData bmData =
                bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), System.Drawing.Imaging.ImageLockMode.WriteOnly,
                System.Drawing.Imaging.PixelFormat.Format24bppRgb);

            // Copy the bytes
            System.Runtime.InteropServices.Marshal.Copy(dispImg, 0, bmData.Scan0, bmData.Stride * bmData.Height);

            // Never forget to unlock the bitmap
            bmp.UnlockBits(bmData);

            //picDisplay.Image = bmp;
            SetImage(bmp);
        }

        public void displayXCorre(byte[] dispImg)
        {
            int i;

            // Create a new Bitmap
            Bitmap bmp = new Bitmap(dispImgW, dispImgH, System.Drawing.Imaging.PixelFormat.Format8bppIndexed);

            // Create grayscale palette
            System.Drawing.Imaging.ColorPalette pal = bmp.Palette;
            for (i = 0; i < 256; ++i)
            {
                pal.Entries[i] = Color.FromArgb((int)255, i, i, i);
            }
            bmp.Palette = pal;

            // Lock it to get the BitmapData Object
            System.Drawing.Imaging.BitmapData bmData =
                bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), System.Drawing.Imaging.ImageLockMode.WriteOnly,
                System.Drawing.Imaging.PixelFormat.Format8bppIndexed);

            // Copy the bytes
            System.Runtime.InteropServices.Marshal.Copy(dispImg, 0, bmData.Scan0, bmData.Stride * bmData.Height);

            // Never forget to unlock the bitmap
            bmp.UnlockBits(bmData);

            //picDisplayXcr.Image = bmp;
        }

        public static int median(int n, int[] x)
        {
            int temp;
            int i, j;
            // the following two loops sort the array x in ascending order
            for (i = 0; i < n - 1; ++i)
            {
                for (j = i + 1; j < n; ++j)
                {
                    if (x[j] < x[i])
                    {
                        // swap elements
                        temp = x[i];
                        x[i] = x[j];
                        x[j] = temp;
                    }
                }
            }

            if (n % 2 == 0)
            {
                // if there is an even number of elements, return mean of the two elements in the middle
                return ((x[n / 2] + x[n / 2 - 1]) / 2);
            }
            else
            {
                return x[n / 2];
            }
        }

        public static int mean(int n, int[] x)
        {
            int temp;
            int i;

            temp = 0;
            for (i = 0; i < n; ++i)
            {
                temp += x[i];
            }

            return (temp / n);
        }

        public static int calc_shift_bit(float max_v, float min_v, float rate)
        {
            int shift_bit = 0;
            float max_abs;

            if (Math.Abs(max_v) > Math.Abs(min_v))
            {
                max_abs = Math.Abs(max_v);
            }
            else
            {
                max_abs = Math.Abs(min_v);
            }

            while (max_abs >= (16384 * rate))
            {
                max_abs = max_abs / 2;
                shift_bit++;
            }

            return shift_bit;
        }

        public static int calc_scale_sch(int shift_bit)
        {
            int scale_sch = 0;

            switch (shift_bit)
            {
                case 0:
                    scale_sch = 0;
                    break;
                case 1:
                    scale_sch = 1;
                    break;
                case 2:
                    scale_sch = 5;
                    break;
                case 3:
                    scale_sch = 21;
                    break;
                case 4:
                    scale_sch = 85;
                    break;
                case 5:
                    scale_sch = 86;
                    break;
                case 6:
                    scale_sch = 90;
                    break;
                case 7:
                    scale_sch = 106;
                    break;
                default:
                    scale_sch = -1;
                    break;
            }
            return scale_sch;
        }

        private void btnStartCapture_Click(object sender, EventArgs e)
        {
            Thread thPlayProcess = new Thread(ExecutePlayProcess);
            byte[] cmd = new byte[20];
            byte[] recv = new byte[4];
            int i, j;

            //if (btnLoadContourConfigClickedBefore)
            //{
            //    checkBoxToggleContours.Enabled = true;
            //    checkBoxToggleContours.Checked = true; //this automatically calls the checkBoxToggleContours_CheckedChanged function.
            //}

            // Clear Max-Projection image.
            for (j = 0; j < dispImgH; ++j)
            {
                for (i = 0; i < dispImgW; ++i)
                {
                    maxProjImg[j * dispImgW + i] = 0;
                }
            }

            if (!TCPsocket.Connected)
            {
                StartClient();
            }

            TCPsocket.ReceiveTimeout = 0;

            cmd[0] = 2;
            cmd[1] = (byte)selectModeIsOffline;
            for (i = 2; i < 20; ++i)
            {
                cmd[i] = 0;
            }

            try
            {
                RTCImgProc.Send(TCPsocket, cmd, 0, 20, 10000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
            }

            try
            {
                RTCImgProc.Receive(TCPsocket, recv, 0, 4, 10000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
            }

            thPlayProcess.IsBackground = true;
            thPlayProcess.Start();

            //while (allowstaticContourToggle) ;
            //checkBoxToggleContours.Enabled = true;
            //radioBtnMaxProj.Enabled = true;
            //radioBtnMeanProj.Enabled = true;
            //radioBtnMinProj.Enabled = true;
            //radioBtnMaxProj.Checked = true;
        }

        private void ExecutePlayProcess()
        {
            int ExecuteTime = 0;
            int i, j, t;
            byte[] cmd = new byte[4];
            byte[] send = new byte[4];
            byte[] recv = new byte[1440];
            int recv_size = 0;
            int recv_pntr = 0;
            // ImgSize: 512x512 = 262144
            // Header: 8
            // Cell traces: 4096
            // Reserved: 152
            byte[] recv_buf = new byte[ImgSize + 8 + 4096 + 152];
            string outputFilename;
            byte[] frameId = new byte[4];
            int received = 0;
            int recvNotComplete = 0;
            int frameId_val = 0;
            int recvId_val = 0;
            int[] accImg = new int[dispImgSize];
            sbyte value = 0;

            FileStream fs;
            BinaryWriter bw;
            outputFilename = work_path.Substring(0, loc) + "file\\record\\image.bin";
            fs = File.Create(outputFilename, ImgSize * 1000, FileOptions.None);
            bw = new BinaryWriter(fs);

            for (i = 0; i < 4; ++i)
            {
                send[i] = 0;
            }

            for (i = 0; i < 4; ++i)
            {
                frameId[i] = 0;
            }
            
            recvId_val = 0;
            Console.WriteLine("[Info] Wait for receiving sync signal...");
            while (recvId_val != 255)
            {
                try
                {
                    TCPsocket.Receive(recv, 4, SocketFlags.None);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }
                recvId_val = recv[0] + (recv[1] << 8) + (recv[2] << 16) + (recv[3] << 24);
                Console.WriteLine("recvId:" + recvId_val.ToString());
            }
            recvId_val = 0;

            TCPsocket.NoDelay = true;
            TCPsocket.ReceiveTimeout = 100;

            do
            {
                if (ExecuteTime < 1000)
                {
                    ExecuteTime++;
                }
                else
                {
                    break;
                }

                recv_pntr = 0;
                
                for (t = 0; t < 185; ++t)
                {
                    recv_size = 0;

                    while (recv_size < 1440)
                    {
                        try
                        {
                            received = 0;
                            received = TCPsocket.Receive(recv, 1440 - recv_size, SocketFlags.None);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                            break;
                        }

                        for (i = 0; i < received; ++i)
                        {
                            recv_buf[recv_pntr + i] = recv[i];
                        }
                        recv_size += received;
                        recv_pntr += received;
                    }

                    if (recv_size < 1440)
                    {
                        recvNotComplete = 1;
                        Console.WriteLine("recv_size: " + recv_size.ToString());
                    }

                    while (recvNotComplete == 1)
                    {
                        Console.WriteLine("[Info] Enter not complete");
 
                        send[0] = 0;
                        try
                        {
                            RTCImgProc.Send(TCPsocket, send, 0, 4, 10000);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                        }

                        Console.WriteLine("[Info] TCP transmission interrupted");
                        while (recv_size < 1440)
                        {
                            try
                            {
                                received = 0;
                                received = TCPsocket.Receive(recv, 1440 - recv_size, SocketFlags.None);
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                                break;
                            }

                            for (i = 0; i < received; ++i)
                            {
                                recv_buf[recv_pntr + i] = recv[i];
                            }
                            recv_size += received;
                            recv_pntr += received;
                        }

                        if (recv_size == 1440)
                        {
                            recvNotComplete = 0;
                            Console.WriteLine("[Info] TCP receive recovered");
                        }
                        else
                        {
                            Console.WriteLine("recv_size: " + recv_size.ToString());
                        }
                    }
                }

                frameId_val = frameId[0] + (frameId[1] << 8) + (frameId[2] << 16) + (frameId[3] << 24);
                recvId_val = recv_buf[0] + (recv_buf[1] << 8) + (recv_buf[2] << 16) + (recv_buf[3] << 24);

                Console.WriteLine("frameId = " + frameId_val.ToString() + " recvId = " + recvId_val.ToString());

                if (recvId_val > frameId_val)
                {
                    for (i = 0; i < 4; ++i)
                    {
                        frameId[i] = recv_buf[i];
                    }
                    Console.WriteLine("[Info] Receive Frame # " + recvId_val.ToString());

                    value = (sbyte)recv_buf[6];
                    if (value == 1)
                    {
                        Console.WriteLine("[Info] Data loss detected at Frame #" + recvId_val.ToString());
                    }

                    for (j = 0; j < dispImgH; ++j)
                    {
                        for (i = 0; i < dispImgW; ++i)
                        {
                            dispImg[j * dispImgW + i] = recv_buf[j * dispImgW + i + 8];

                            // Update Max-Projection image.
                            if (dispImg[j * dispImgW + i] > maxProjImg[j * dispImgW + i])
                                maxProjImg[j * dispImgW + i] = dispImg[j * dispImgW + i];
                        }
                    }
                    displayImage(dispImg);

                    bw.Write(recv_buf, 8, ImgSize);
                }

            } while (true);


            cmd[0] = 4;
            try
            {
                RTCImgProc.Send(TCPsocket, cmd, 0, 4, 10000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
            }

            fs.Close();

            //for (i = 0; i < dispImgSize - 1; ++i)
            //    meanProjImg[i] = (byte) (accImg[i] / 999);
            displayImage(maxProjImg);
            //allowstaticContourToggle = true;

            MessageBox.Show("Finish Image Capture");
        }

        private void btnSaveImg_Click(object sender, EventArgs e)
        {
            string outputFilename;
            
            outputFilename = work_path.Substring(0, loc) + "file\\save\\sav_image.bmp";
            picDisplay.Image.Save(outputFilename, System.Drawing.Imaging.ImageFormat.Bmp);
            MessageBox.Show("Image Saved");
        }

        private void btnStartMCorre_Click(object sender, EventArgs e)
        {
            //allowstaticContourToggle = false;
            Thread thPlayProcess = new Thread(ExecuteMCorreProcess);
            byte[] cmd = new byte[20];
            byte[] recv = new byte[4];

            int roi_row_start = 0;
            int roi_col_start = 0;
            byte[] template = new byte[20736];
            byte[] fileBytes;

            int i, j;
            //int cur_pnt = 0;
            string inputFilename;
            string[] fileLines;
            //int recvId_val = 0;

            if (!TCPsocket.Connected)
            {
                StartClient();
            }
            
            TCPsocket.ReceiveTimeout = 0;

            if (recordingIsOn == 0)
            {
                recordingIsOn = 1;
                btnStartMCorre.Text = "Stop Motion Correction";
                
                inputFilename = work_path.Substring(0, loc) + "file\\template\\template.txt";
                fileLines = File.ReadAllLines(inputFilename);
                for (j = 0; j < (SUB_H + 16); ++j)
                {
                    for (i = 0; i < (SUB_W + 16); ++i)
                    {
                        template[j * (SUB_W + 16) + i] = Convert.ToByte(fileLines[j * (SUB_W + 16) + i]);
                    }
                }

                roi_row_start = Convert.ToInt32(textBoxROIr.Text);
                roi_col_start = Convert.ToInt32(textBoxROIc.Text);
                
                cmd[0] = 3;
                cmd[1] = (byte)selectModeIsOffline;
                cmd[2] = (byte)(roi_row_start % 256);
                cmd[3] = (byte)(roi_row_start / 256);
                cmd[4] = (byte)(roi_col_start % 256);
                cmd[5] = (byte)(roi_col_start / 256);
                cmd[6] = (byte)bypassTemplate;

                for (i = 7; i < 20; ++i)
                {
                    cmd[i] = 0;
                }

                try
                {
                    RTCImgProc.Send(TCPsocket, cmd, 0, 20, 10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }

                try
                {
                    RTCImgProc.Receive(TCPsocket, recv, 0, 4, 10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }
                
                // Download template file.
                try
                {
                    RTCImgProc.Send(TCPsocket, template, 0, 20736, 10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }

                try
                {
                    RTCImgProc.Receive(TCPsocket, recv, 0, 4, 10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }

                // Download contour file: trace_mem.bin
                inputFilename = work_path.Substring(0, loc) + "file\\contour\\tracer_mem.bin";
                fileBytes = File.ReadAllBytes(inputFilename);

                try
                {
                    RTCImgProc.Send(TCPsocket, fileBytes, 0, 86272, 10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }

                try
                {
                    RTCImgProc.Receive(TCPsocket, recv, 0, 4, 10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }

                // Download parameter file: param.bin
                inputFilename = work_path.Substring(0, loc) + "file\\param\\param.bin";
                fileBytes = File.ReadAllBytes(inputFilename);

                try
                {
                    RTCImgProc.Send(TCPsocket, fileBytes, 0, 94300, 10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }

                try
                {
                    RTCImgProc.Receive(TCPsocket, recv, 0, 4, 10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }

                thPlayProcess.IsBackground = true;
                thPlayProcess.Start();
            }
            else
            {
                recordingIsOn = 0;
                btnStartMCorre.Text = "Start Motion Correction";
            }
        }

        private void ExecuteMCorreProcess()
        {
            int ExecuteTime = 0;
            int i, j, t;
            int cell;
            int c;
            int row, col;
            int [] pre_trace = new int[63];
            int [] cur_trace = new int[63];
            byte[] cmd = new byte[4];
            byte[] send = new byte[4];
            byte[] recv = new byte[1440];
            // ImgSize: 512x512 = 262144
            // Header: 8
            // Cell traces: 4096
            // Reserved: 152
            byte[] recv_buf = new byte[ImgSize + 8 + 4096 + 152];

            int recv_size = 0;
            int recv_pntr = 0;
            int received = 0;
            int recvNotComplete = 0;

            sbyte mot_x = 0;
            sbyte mot_y = 0;
            sbyte value = 0;
            byte[] syncPattern = new byte[4];
            byte[] frameId = new byte[4];
            string outputDirectory;
            string imageFilename;
            string dataFilename;
            string text;
            var time = DateTime.Now;
            string formattedTime = time.ToString("yyyyMMdd_hh_mm_ss");
            FileStream fs_image;
            FileStream fs_data;
            BinaryWriter bw_image;
            BinaryWriter bw_data;

            //int startTickCount = 0;
            int frameId_val = 0;
            int recvId_val = 0;
            
            int[] trace = new int[cellNum];
            int[] norm_trace = new int[63 * 1000];

            // Parameters for Group-Max
            int[] tid = new int[63] {  5,   8,  28,  34,  40,  44,  49,  64,  68,
                                      71,  84, 100, 118, 123, 133, 139, 143, 145,
                                     147, 148, 149, 150, 155, 156, 172, 174, 178,
                                     179, 188, 194, 197, 201, 209, 232, 241, 245,
                                     256, 260, 265, 266, 292, 294, 313, 335, 400,
                                     431, 456, 474, 476, 523, 606, 611, 668, 803,
                                     835, 904, 934, 949, 968, 971, 978, 991, 993};

            int[] min = new int[63] { 0,  74, 22, 13, 30,  42, 49, 152,  84,
                                      3,  72, 13, 85,  8,   0,  1,  59,   0,
                                      9,  21, 18, 11, 49,  19, 20,   7,   5,
                                      4,   0, 37,  4, 82, 118,  9,  31,  13,
                                      2,   3,  0, 32,  2,  22, 14, 103,   0,
                                      0,   5, 28, 33, 84, 109, 21,   0,   8,
                                     64, 127,  3, 80,  4,   0, 91,  21, 100};

            int[] max = new int[63] { 993, 1507, 1033,  946, 1074, 1533, 1224, 1270, 2005,
                                     1015, 1507, 1261,  978, 1234,  973, 1186, 1171, 1218,
                                      947, 1028,  966, 2439, 1257, 1165, 1243, 1598,  947,
                                     1752,  987,  980, 1002, 1351, 1014, 1124, 2161, 1840,
                                     1116, 1851, 1108, 1650, 1071,  983,  995, 1529, 1036,
                                     1002, 1021, 1086, 1288, 1104, 1130, 1020, 1080,  944,
                                     1088, 1040, 1173, 1081, 1424, 1209, 1418, 1246, 1143};

            outputDirectory = work_path.Substring(0, loc) + "file\\acquire\\" + formattedTime + "\\";
            Directory.CreateDirectory(outputDirectory);  // create directory
            imageFilename = outputDirectory + "msImage.bin";
            dataFilename = outputDirectory + "msData.bin";
            fs_image = File.Create(imageFilename);
            fs_data = File.Create(dataFilename);
            bw_image = new BinaryWriter(fs_image);
            bw_data = new BinaryWriter(fs_data);

            StreamWriter traceFile = new StreamWriter(work_path.Substring(0, loc) + "file\\trace\\trace.txt");
            
            for (i = 0; i < 4; ++i)
            {
                syncPattern[i] = 255;
                frameId[i] = 0;
                send[i] = 0;
            }

            bw_image.Write(syncPattern);
            bw_image.Write(frameId);
            bw_image.Write(recv_buf, 8, ImgSize);

            for (i = 0; i < 4; ++i)
            {
                recv_buf[i] = frameId[i];
            }
            recv_buf[4] = (byte)(Convert.ToInt32(textBoxROIr.Text) % 256);
            recv_buf[5] = (byte)(Convert.ToInt32(textBoxROIr.Text) / 256);
            recv_buf[6] = (byte)(Convert.ToInt32(textBoxROIc.Text) % 256);
            recv_buf[7] = (byte)(Convert.ToInt32(textBoxROIc.Text) / 256);

            bw_data.Write(syncPattern);
            bw_data.Write(recv_buf, 0, 8);

            recvId_val = 0;
            Console.WriteLine("[Info] Wait for receiving sync signal...");
            while (recvId_val != 255)
            {
                try
                {
                    TCPsocket.Receive(recv, 4, SocketFlags.None);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }
                recvId_val = recv[0] + (recv[1] << 8) + (recv[2] << 16) + (recv[3] << 24);
            }
            recvId_val = 0;

            TCPsocket.NoDelay = true;
            TCPsocket.ReceiveTimeout = 100;

            do
            {
                if (ExecuteTime < 1000)
                {
                    ExecuteTime++;
                }
                else
                {
                    break;
                }
                
                recv_pntr = 0;

                for (t = 0; t < 185; ++t)
                {
                    recv_size = 0;

                    while (recv_size < 1440)
                    {
                        try
                        {
                            received = 0;
                            received = TCPsocket.Receive(recv, 1440 - recv_size, SocketFlags.None);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                            break;
                        }

                        for (i = 0; i < received; ++i)
                        {
                            recv_buf[recv_pntr + i] = recv[i];
                        }
                        recv_size += received;
                        recv_pntr += received;
                    }

                    if (recv_size < 1440)
                    {
                        recvNotComplete = 1;
                    }

                    while (recvNotComplete == 1)
                    {
                        Console.WriteLine("[Info] Enter not complete");
                        send[0] = 0;
                        try
                        {
                            RTCImgProc.Send(TCPsocket, send, 0, 4, 10000);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                        }

                        Console.WriteLine("[Info] TCP transmission interrupted");
                        while (recv_size < 1440)
                        {
                            try
                            {
                                received = 0;
                                received = TCPsocket.Receive(recv, 1440 - recv_size, SocketFlags.None);
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                                break;
                            }

                            for (i = 0; i < received; ++i)
                            {
                                recv_buf[recv_pntr + i] = recv[i];
                            }
                            recv_size += received;
                            recv_pntr += received;
                        }

                        if (recv_size == 1440)
                        {
                            recvNotComplete = 0;
                            Console.WriteLine("[Info] TCP receive recovered");
                        }
                    }
                }

                frameId_val = frameId[0] + (frameId[1] << 8) + (frameId[2] << 16) + (frameId[3] << 24);
                recvId_val = recv_buf[0] + (recv_buf[1] << 8) + (recv_buf[2] << 16) + (recv_buf[3] << 24);

                if (recvId_val > frameId_val)
                {
                    for (i = 0; i < 4; ++i)
                    {
                        frameId[i] = recv_buf[i];
                    }
                    //Console.WriteLine("[Info] Receive Frame # " + recvId_val.ToString());

                    mot_x = (sbyte)recv_buf[4];
                    mot_y = (sbyte)recv_buf[5];
                    //Console.WriteLine(ExecuteTime.ToString() + ":" + mot_x.ToString() + " " + mot_y.ToString());

                    value = (sbyte)recv_buf[6];
                    if (value == 1)
                    {
                        Console.WriteLine("[Info] Data loss detected at Frame #" + recvId_val.ToString());
                    }

                    trace[0] = recv_buf[ImgSize + 8 + 0] + (recv_buf[ImgSize + 8 + 1] << 8);
                    //Console.WriteLine(trace[0].ToString());
                    text = trace[0].ToString();
                    for (i = 1; i < cellNum; ++i)
                    {
                        trace[i] = recv_buf[ImgSize + 8 + i * 2] + (recv_buf[ImgSize + 8 + i * 2 + 1] << 8);
                        text = text + "," + trace[i].ToString();
                    }
                    traceFile.WriteLine(text);

                    // Display one frame of image
                    if (displayMode == 0)
                    {
                        for (j = 0; j < dispImgH; ++j)
                        {
                            for (i = 0; i < dispImgW; ++i)
                            {
                                //dispImg[j * dispImgW + i] = recv_buf[j * dispImgW + i + 8];
                                for (c = 0; c < 3; ++c)
                                {
                                    dispRGBImg[(j * dispImgW + i) * 3 + c] = recv_buf[j * dispImgW + i + 8];
                                }
                            }
                        }
                    }
                    else if (displayMode == 1)
                    {
                        for (j = 0; j < dispImgH; ++j)
                        {
                            for (i = 0; i < dispImgW; ++i)
                            {
                                if ((mot_x > -20) && (mot_x < 20) && (mot_y > -20) && (mot_y < 20))
                                {
                                    if (((j - mot_y) >= 0) && ((j - mot_y) < ImgH) && ((i - mot_x) >= 0) && ((i - mot_x) < ImgW))
                                    {
                                        //dispImg[j * dispImgW + i] = recv_buf[(j - mot_y) * dispImgW + (i - mot_x) + 8];
                                        for (c = 0; c < 3; ++c)
                                        {
                                            dispRGBImg[(j * dispImgW + i) * 3 + c] = recv_buf[(j - mot_y) * dispImgW + (i - mot_x) + 8];
                                        }
                                    }
                                }
                                else
                                {
                                    //dispImg[j * dispImgW + i] = recv_buf[j * dispImgW + i + 8];
                                    for (c = 0; c < 3; ++c)
                                    {
                                        dispRGBImg[(j * dispImgW + i) * 3 + c] = recv_buf[j * dispImgW + i + 8];
                                    }
                                }
                            }
                        }

                        for (cell = 0; cell < 63; ++cell)
                        {
                            for (j = 0; j < 25; ++j)
                            {
                                for (i = 0; i < 25; ++i)
                                {
                                    //if (contourMaps[tid[cell] - 1, j, i] == 1)
                                    if (contourMaps[Tid[cur_group, cell], j, i] == 1)
                                    {
                                        //row = cellLoc[tid[cell] - 1].X - 12 + j;
                                        //col = cellLoc[tid[cell] - 1].Y - 12 + i;
                                        row = cellLoc[Tid[cur_group, cell]].X - 12 + j;
                                        col = cellLoc[Tid[cur_group, cell]].Y - 12 + i;
                                        for (c = 0; c < 3; ++c)
                                        {
                                            dispRGBImg[(row * dispImgW + col) * 3 + c] = color[(cell % 7) * 3 + c];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //displayImage(dispImg);
                    displayRGBImage(dispRGBImg);
                    
                    // Display one frame of trace
                    for (j = 0; j < dispTraceH; ++j)
                    {
                        for (i = 0; i < dispTraceW; ++i)
                        {
                            for (c = 0; c < 3; ++c)
                            {
                                dispRGBTrace[(j * dispTraceW + i) * 3 + c] = 255;
                            }
                        }
                    }

                    for (cell = 0; cell < 63; ++cell)
                    {
                        //norm_trace[cell * 1000 + (ExecuteTime - 1)] = (trace[tid[cell] - 1] - min[cell]) * 15 / (max[cell] - min[cell]);
                        norm_trace[cell * 1000 + (ExecuteTime - 1)] = (trace[Tid[cur_group, cell]] - Min[cur_group, cell]) * 15 / (Max[cur_group, cell] - Min[cur_group, cell]);
                    }
                    //Console.WriteLine(norm_trace[ExecuteTime - 1].ToString());
                    
                    if (ExecuteTime <= 400)
                    {
                        for (cell = 0; cell < 63; ++cell)
                        {
                            for (i = 0; i < ExecuteTime; ++i)
                            {
                                cur_trace[cell] = 15 - norm_trace[cell * 1000 + i];
                                if (i == 0)
                                {
                                    pre_trace[cell] = cur_trace[cell];
                                }
                                else
                                {
                                    pre_trace[cell] = 15 - norm_trace[cell * 1000 + i - 1];
                                }

                                if (cur_trace[cell] > pre_trace[cell])
                                {
                                    for (j = pre_trace[cell] + 1; j <= cur_trace[cell]; ++j)
                                    {
                                        for (c = 0; c < 3; ++c)
                                        {
                                            dispRGBTrace[((cell * 8 + j) * dispTraceW + i) * 3 + c] = color[(cell % 7) * 3 + c];
                                        }
                                    }
                                }
                                else if (cur_trace[cell] < pre_trace[cell])
                                {
                                    for (j = pre_trace[cell] - 1; j >= cur_trace[cell]; --j)
                                    {
                                        for (c = 0; c < 3; ++c)
                                        {
                                            dispRGBTrace[((cell * 8 + j) * dispTraceW + i) * 3 + c] = color[(cell % 7) * 3 + c];
                                        }
                                    }
                                }
                                else
                                {
                                    j = cur_trace[cell];
                                    for (c = 0; c < 3; ++c)
                                    {
                                        dispRGBTrace[((cell * 8 + j) * dispTraceW + i) * 3 + c] = color[(cell % 7) * 3 + c];
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        for (cell = 0; cell < 63; ++cell)
                        {
                            for (i = 0; i < 400; ++i)
                            {
                                cur_trace[cell] = 15 - norm_trace[cell * 1000 + i + ExecuteTime - 400];
                                pre_trace[cell] = 15 - norm_trace[cell * 1000 + i + ExecuteTime - 400 - 1];

                                if (cur_trace[cell] > pre_trace[cell])
                                {
                                    for (j = pre_trace[cell] + 1; j <= cur_trace[cell]; ++j)
                                    {
                                        for (c = 0; c < 3; ++c)
                                        {
                                            dispRGBTrace[((cell * 8 + j) * dispTraceW + i) * 3 + c] = color[(cell % 7) * 3 + c];
                                        }
                                    }
                                }
                                else if (cur_trace[cell] < pre_trace[cell])
                                {
                                    for (j = pre_trace[cell] - 1; j >= cur_trace[cell]; --j)
                                    {
                                        for (c = 0; c < 3; ++c)
                                        {
                                            dispRGBTrace[((cell * 8 + j) * dispTraceW + i) * 3 + c] = color[(cell % 7) * 3 + c];
                                        }
                                    }
                                }
                                else
                                {
                                    j = cur_trace[cell];
                                    for (c = 0; c < 3; ++c)
                                    {
                                        dispRGBTrace[((cell * 8 + j) * dispTraceW + i) * 3 + c] = color[(cell % 7) * 3 + c];
                                    }
                                }
                            }
                        }
                    }
                    displayRGBTrace(dispRGBTrace);

                    bw_image.Write(syncPattern);
                    bw_image.Write(frameId);
                    bw_image.Write(recv_buf, 8, ImgSize);

                    bw_data.Write(syncPattern);
                    bw_data.Write(recv_buf, 0, 8);
                }
            } while (true);

            // Close the trace recording file.
            traceFile.Close();

            cmd[0] = 4;
            try
            {
                RTCImgProc.Send(TCPsocket, cmd, 0, 4, 10000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
            }

            fs_image.Close();
            fs_data.Close();

            //allowstaticContourToggle = true;
            MessageBox.Show("Finish Real-Time Demo");
        }


        private void picDisplay_MouseMove(object sender, MouseEventArgs e)
        {
            int roi_c = 0;
            int roi_r = 0;

            roi_c = e.X * ImgW / picDisplay.Width - 64;
            roi_r = e.Y * ImgH / picDisplay.Height - 64;

            if (selectROIstate == 1)
            {

                RcDraw.X = roi_c * picDisplay.Width / ImgW;
                RcDraw.Y = roi_r * picDisplay.Height / ImgH;
                RcDraw.Width = 128 * picDisplay.Width / ImgW;
                RcDraw.Height = 128 * picDisplay.Height / ImgH;
                picDisplay.Invalidate();
            }
        }

        private void picDisplay_Paint(object sender, PaintEventArgs e)
        {
            e.Graphics.DrawRectangle(new Pen(Color.Red, PenWidth), RcDraw);
        }

        private void btnSelectROI_Click(object sender, EventArgs e)
        {
            if (selectROIstate == 0)
            {
                selectROIstate = 1;
                btnComputeTemplate.Enabled = true;
                btnSelectROI.Text = "Remove ROI";

                textBoxROIc.Text = "192";
                textBoxROIr.Text = "192";
                RcDraw.X = 192 * picDisplay.Width / ImgW;
                RcDraw.Y = 192 * picDisplay.Height / ImgH;
                RcDraw.Width = 128 * picDisplay.Width / ImgW;
                RcDraw.Height = 128 * picDisplay.Height / ImgH;
                picDisplay.Invalidate();
            }
            else if (selectROIstate != 0)
            {
                selectROIstate = 0;
                btnComputeTemplate.Enabled = false;
                btnSelectROI.Text = "Select ROI";

                RcDraw.Width = 0;
                RcDraw.Height = 0;
                picDisplay.Invalidate();
            }
        }

        private void picDisplay_MouseDown(object sender, MouseEventArgs e)
        {
            int roi_c = 0;
            int roi_r = 0;

            if (selectROIstate == 1)
            {
                roi_c = e.X * ImgW / picDisplay.Width - 64;
                roi_r = e.Y * ImgH / picDisplay.Height - 64;
                if ((roi_c < 9) || (roi_c > 375) || (roi_r < 9) || (roi_r > 375))
                {
                    MessageBox.Show("ROI boundary is out of range.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                }
                else
                {
                    selectROIstate = 2;
                    textBoxROIc.Text = roi_c.ToString();
                    textBoxROIr.Text = roi_r.ToString();
                }
            }
        }

        private void btnDownloadImg_Click(object sender, EventArgs e)
        {
            byte[] cmd = new byte[20];
            byte[] recv = new byte[4];
            int i, t;

            byte[] image_data = new byte[262144];
            string inputFilename;
            byte[] fileBytes;
            
            if (!TCPsocket.Connected)
            {
                StartClient();
            }

            TCPsocket.ReceiveTimeout = 0;

            cmd[0] = 1;
            for (i = 1; i < 20; ++i)
            {
                cmd[i] = 0;
            }

            try
            {
                RTCImgProc.Send(TCPsocket, cmd, 0, 20, 10000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
            }

            try
            {
                RTCImgProc.Receive(TCPsocket, recv, 0, 4, 10000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
            }

            for (t = 0; t < 1000; ++t)
            {
                inputFilename = work_path.Substring(0, loc) + "file\\image\\image_f" + t.ToString().PadLeft(3, '0') + ".bin";
                fileBytes = File.ReadAllBytes(inputFilename);
                
                try
                {
                    RTCImgProc.Send(TCPsocket, fileBytes, 0, 262144, 10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }

                try
                {
                    RTCImgProc.Receive(TCPsocket, recv, 0, 4, 10000);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                }
            }

            cmd[0] = 4;
            for (i = 1; i < 20; ++i)
            {
                cmd[i] = 0;
            }

            try
            {
                RTCImgProc.Send(TCPsocket, cmd, 0, 20, 10000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
            }

            MessageBox.Show("Download Complete");
        }

        private void checkBoxDisplayMC_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBoxDisplayMC.Checked == true)
            {
                displayMode = 1;
            }
            else
            {
                displayMode = 0;
            }
        }

        private void btnModeSel_Click(object sender, EventArgs e)
        {
            if (selectModeIsOffline == 0)
            {
                selectModeIsOffline = 1;
                btnModeSel.Text = "Offline";
            }
            else if (selectModeIsOffline == 1)
            {
                selectModeIsOffline = 0;
                btnModeSel.Text = "Online";
            }
        }

        private void textBoxROIr_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                if (selectROIstate != 0)
                {
                    int roi_c = 0;
                    int roi_r = 0;
                    roi_c = Convert.ToInt32(textBoxROIc.Text);
                    roi_r = Convert.ToInt32(textBoxROIr.Text);

                    if ((roi_c < 9) || (roi_c > 375) || (roi_r < 9) || (roi_r > 375))
                    {
                        MessageBox.Show("ROI boundary is out of range.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    }
                    else
                    {
                        selectROIstate = 2;
                        RcDraw.X = roi_c * picDisplay.Width / ImgW;
                        RcDraw.Y = roi_r * picDisplay.Height / ImgH;
                        RcDraw.Width = 128 * picDisplay.Width / ImgW;
                        RcDraw.Height = 128 * picDisplay.Height / ImgH;
                        picDisplay.Invalidate();
                    }
                }
            }
        }

        private void textBoxROIc_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                if (selectROIstate != 0)
                {
                    int roi_c = 0;
                    int roi_r = 0;
                    roi_c = Convert.ToInt32(textBoxROIc.Text);
                    roi_r = Convert.ToInt32(textBoxROIr.Text);

                    if ((roi_c < 9) || (roi_c > 375) || (roi_r < 9) || (roi_r > 375))
                    {
                        MessageBox.Show("ROI boundary is out of range.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    }
                    else
                    {
                        selectROIstate = 2;
                        RcDraw.X = roi_c * picDisplay.Width / ImgW;
                        RcDraw.Y = roi_r * picDisplay.Height / ImgH;
                        RcDraw.Width = 128 * picDisplay.Width / ImgW;
                        RcDraw.Height = 128 * picDisplay.Height / ImgH;
                        picDisplay.Invalidate();
                    }
                }
            }
        }

        private void btnSwitchCell_Click(object sender, EventArgs e)
        {
            int i, j;
            int cell;
            int c;
            int row = 0, col = 0;

            // Switch cell group ID: 0 ~ 11 (In total: 12 groups)
            if (cur_group < 11)
                cur_group++;
            else
                cur_group = 0;

            switch (cur_group)
            {
                case 0:
                    cellText.Text = "Cell Number: 1 - 63";
                    break;

                case 1:
                    cellText.Text = "Cell Number: 64 - 126";
                    break;

                case 2:
                    cellText.Text = "Cell Number: 127 - 189";
                    break;

                case 3:
                    cellText.Text = "Cell Number: 190 - 252";
                    break;

                case 4:
                    cellText.Text = "Cell Number: 253 - 315";
                    break;

                case 5:
                    cellText.Text = "Cell Number: 316 - 378";
                    break;

                case 6:
                    cellText.Text = "Cell Number: 379 - 441";
                    break;

                case 7:
                    cellText.Text = "Cell Number: 442 - 504";
                    break;

                case 8:
                    cellText.Text = "Cell Number: 505 - 567";
                    break;

                case 9:
                    cellText.Text = "Cell Number: 568 - 630";
                    break;

                case 10:
                    cellText.Text = "Cell Number: 631 - 693";
                    break;

                case 11:
                    cellText.Text = "Cell Number: 694 - 756";
                    break;

                default:
                    cellText.Text = "Cell Number: 1 - 63";
                    break;
            }

            for (j = 0; j < dispImgH; ++j)
            {
                for (i = 0; i < dispImgW; ++i)
                {
                    for (c = 0; c < 3; ++c)
                    {
                        dispRGBImg[(j * dispImgW + i) * 3 + c] = maxProjImg[j * dispImgW + i];
                    } 
                }
            }

            for (cell = 0; cell < 63; ++cell)
            {
                for (j = 0; j < 25; ++j)
                {
                    for (i = 0; i < 25; ++i)
                    {
                        if (contourMaps[Tid[cur_group, cell], j, i] == 1)
                        {
                            row = cellLoc[Tid[cur_group, cell]].X - 12 + j;
                            col = cellLoc[Tid[cur_group, cell]].Y - 12 + i;
                            for (c = 0; c < 3; ++c)
                            {
                                dispRGBImg[(row * dispImgW + col) * 3 + c] = color[(cell % 7) * 3 + c];
                                //dispRGBImg[(row * dispImgW + col) * 3 + c] = 255;
                            }
                        }
                    }
                }
            }

            Console.WriteLine(color[0].ToString() + " " + color[1].ToString() + " " + color[2].ToString());
            
            displayRGBImage(dispRGBImg);
        }

        private void btnComputeTemplate_Click(object sender, EventArgs e)
        {
            int i, j, t;

            int roi_row_start = 0;
            int roi_col_start = 0;

            string inputFilename;
            string outputFilename;
            byte[] fileBytes;
            byte[,,] imgS = new byte[30, SUB_H + 16, SUB_W + 16];
            int[] element = new int[30];
            byte[] template = new byte[(SUB_H + 16) * (SUB_W + 16)];
            string[] fileLines = new string[(SUB_H + 16) * (SUB_W + 16)];

            roi_row_start = Convert.ToInt32(textBoxROIr.Text);
            roi_col_start = Convert.ToInt32(textBoxROIc.Text);
            
            inputFilename = work_path.Substring(0, loc) + "file\\record\\image.bin";
            fileBytes = File.ReadAllBytes(inputFilename);

            for (t = 0; t < 30; ++t)
            {
                for (j = 0; j < (SUB_H + 16); ++j)
                {
                    for (i = 0; i < (SUB_W + 16); ++i)
                    {
                        imgS[t, j, i] = fileBytes[t * 33 * ImgSize + (j + roi_row_start - 8 - 1) * ImgW + (i + roi_col_start - 8 - 1)];
                        /*
                        if ((i == 0) && (j == 0))
                        {
                            Console.WriteLine(imgS[t, 0, 0].ToString());
                        }
                        */
                    }
                }
            }

            // Compute template
            for (j = 0; j < (SUB_H + 16); ++j)
            {
                for (i = 0; i < (SUB_W + 16); ++i)
                {
                    for (t = 0; t < 30; ++t)
                    {
                        element[t] = imgS[t, j, i];
                    }
                    template[j * (SUB_W + 16) + i] = (byte)mean(30, element);
                }
            }

            for (j = 0; j < (SUB_H + 16); ++j)
            {
                for (i = 0; i < (SUB_W + 16); ++i)
                {
                    fileLines[j * (SUB_W + 16) + i] = template[j * (SUB_W + 16) + i].ToString();
                }
            }

            outputFilename = work_path.Substring(0, loc) + "file\\template\\template.txt";
            File.WriteAllLines(outputFilename, fileLines);

            MessageBox.Show("Extract template completed.", "Notification", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void btnLoadContourConfig_Click(object sender, EventArgs e)
        {
            var fileContent = string.Empty;
            var filePath = string.Empty;
            string lineOne = "";
            int i, j, k;
            int pnt = 0;
            int cnt = 0;

            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                openFileDialog.InitialDirectory = work_path.Substring(0, loc) + "file\\contour";
                openFileDialog.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*";
                openFileDialog.FilterIndex = 1;
                openFileDialog.RestoreDirectory = true;

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    //Get the path of specified file
                    filePath = openFileDialog.FileName;

                    //Read the contents of the file into a stream
                    var fileStream = openFileDialog.OpenFile();

                    using (StreamReader reader = new StreamReader(fileStream))
                    {
                        lineOne = reader.ReadLine();
                        if (lineOne.Substring(0, 8) != "CELL_NUM" && lineOne.Substring(0, 8) != "cell_num")
                        {
                            MessageBox.Show("Please change the first line of your configuration file to CELL_NUM followed by a space and the number of cells.");
                        }
                        else
                        {
                            // Get the number of cells.
                            cellNum = Int16.Parse(lineOne.Substring(9));

                            for (i = 1; i <= cellNum; i++)
                            {
                                reader.ReadLine(); //reads the line telling us which cell number it is, but we don't need to do anything with this info.
                                string lineTwo = reader.ReadLine();
                                int breakpoint1 = lineTwo.IndexOf(',', 0, lineTwo.Length);
                                int endIndex1 = lineTwo.IndexOf('>', breakpoint1);
                                cellLoc[i - 1] = new Point(Int16.Parse(lineTwo.Substring(1, breakpoint1 - 1)),
                                                       Int16.Parse(lineTwo.Substring(breakpoint1 + 1, endIndex1 - breakpoint1 - 1)));

                                //string lineThree = reader.ReadLine();
                                //int breakpoint2 = lineThree.IndexOf(',', 0, lineThree.Length);
                                //normFactors[i - 1] = new Point(Int32.Parse(lineThree.Substring(0, breakpoint2)),
                                //                               Int16.Parse(lineThree.Substring(breakpoint2 + 2)));

                                for (j = 1; j <= 25; j++)
                                {
                                    string line = reader.ReadLine();
                                    string[] stringNums = line.Substring(1, (2 * 25 - 1)).Split(',');
                                    for (k = 1; k <= stringNums.Length; k++)
                                    {
                                        contourMaps[i - 1, j - 1, k - 1] = Int16.Parse(stringNums[k - 1]);
                                    }
                                }
                            }
                        }
                        MessageBox.Show("Contours loaded.");
                        btnLoadContourConfigClickedBefore = true;
                    }
                    
                    // Get the path of the max_min_range.txt file.
                    openFileDialog.FileName = work_path.Substring(0, loc) + "file\\contour\\max_min_range.txt";

                    //Read the contents of the file into a stream
                    fileStream = openFileDialog.OpenFile();

                    using (StreamReader reader = new StreamReader(fileStream))
                    {
                        for (i = 1; i <= 1024; i++)
                        {
                            lineOne = reader.ReadLine();

                            int breakpoint = lineOne.IndexOf(',', 0, lineOne.Length);

                            MaxMin[i - 1, 0] = Int16.Parse(lineOne.Substring(0, breakpoint));
                            MaxMin[i - 1, 1] = Int16.Parse(lineOne.Substring(breakpoint + 1));
                        }
                        
                        pnt = 0;
                        for (j = 0; j < 12; ++j)
                        {
                            cnt = 0;
                            while (cnt < 63)
                            {
                                if (!((MaxMin[pnt, 0] == 0) && (MaxMin[pnt, 1] == 0)))
                                {
                                    Tid[j, cnt] = pnt;
                                    Min[j, cnt] = MaxMin[pnt, 0];
                                    Max[j, cnt] = MaxMin[pnt, 1];
                                    cnt++;
                                }
                                pnt++;
                            }
                        }
                    }
                }
            }
        }

        private void checkBoxToggleContours_CheckedChanged(object sender, EventArgs e)
        {
            //if (imageCaptureFinished && (startMC == finishMC) && (startPlayback == finishPlayback)) // no frames are being actively displayed in the GUI atm.
            if (allowstaticContourToggle)
            {
                if (checkBoxToggleContours.Checked)
                {
                    if (radioBtnMaxProj.Checked)
                    {
                        maskArray = createMask(maxProjImg);
                    }
                    else if (radioBtnMeanProj.Checked)
                    {
                        maskArray = createMask(meanProjImg);
                    }
                    else if (radioBtnMinProj.Checked)
                    {
                        maskArray = createMask(minProjImg);
                    }
                    displayRGBImage(maskArray);
                }

                else //toggle contours off
                {
                    if (radioBtnMaxProj.Checked)
                    {
                        displayImage(maxProjImg);
                    }
                    else if (radioBtnMeanProj.Checked)
                    {
                        displayImage(meanProjImg);
                    }
                    else if (radioBtnMinProj.Checked)
                    {
                        displayImage(minProjImg);
                    }
                }
            }
            picDisplay.Invalidate();
        }

        private void radioBtnMaxProj_CheckedChanged(object sender, EventArgs e)
        {
            if (radioBtnMaxProj.Checked)
            {
                displayImage(maxProjImg);

                if (checkBoxToggleContours.Checked)
                {
                    checkBoxToggleContours.Checked = false;
                }
            }
        }

        private void radioBtnMeanProj_CheckedChanged(object sender, EventArgs e)
        {
            if (radioBtnMeanProj.Checked)
            {
                displayImage(meanProjImg);

                if (checkBoxToggleContours.Checked)
                {
                    checkBoxToggleContours.Checked = false;
                }
            }
        }

        private void radioBtnMinProj_CheckedChanged(object sender, EventArgs e)
        {
            if (radioBtnMinProj.Checked)
            {
                displayImage(minProjImg);

                if (checkBoxToggleContours.Checked)
                {
                    checkBoxToggleContours.Checked = false;
                }
            }
        }

        /* Takes in a byte[] of size dispImgSize. Returns a masked / contoured form of the image of size dispImgSize * 3 
         * (making it compatible with the displayRGBImage method format). */
        private byte[] createMask(byte[] img)
        {
            int i;
            int cell;
            int row, col;
            int x, y;
            byte[] maskedBigArray = new byte[img.Length * 3];
            byte[] maskedSmallArray = new byte[img.Length];
            for (i = 0; i < img.Length; i++)
            {
                maskedSmallArray[i] = img[i]; //creates a copy of the input parameter. avoids altering the image itself.
            }

            for (cell = 0; cell < cellNum; cell++)
            {
                for (row = 0; row < 25; row++)
                {
                    for (col = 0; col < 25; col++)
                    {
                        if (contourMaps[cell, row, col] == 1)
                        {
                            x = (col + cellLoc[cell].Y - 12 + 4/2) * picDisplay.Width / dispImgW;
                            y = (row + cellLoc[cell].X - 12 + 3/2) * picDisplay.Height / dispImgH;
                            maskedSmallArray[y * dispImgW + x] = 0; //maybe switch to 120?
                        }
                    }
                }
            }

            for (row = 0; row < dispImgH; row++)
            {
                for (col = 0; col < dispImgW; col++)
                {
                    maskedBigArray[(row * dispImgW + col) * 3 + 0] = img[row * dispImgW + col]; //b
                    maskedBigArray[(row * dispImgW + col) * 3 + 1] = img[row * dispImgW + col]; //g
                    maskedBigArray[(row * dispImgW + col) * 3 + 2] = maskedSmallArray[row * dispImgW + col]; //r
                }
            }

            return maskedBigArray;
        }

        private void btnTest_Click(object sender, EventArgs e)
        {
            byte[] cmd = new byte[20];
            byte[] recv = new byte[360960];
            byte[] send = new byte[360960];
            int i, t;
            int received = 0;
            int recv_mem_size = 0;
            int recvNotComplete = 0;

            if (!TCPsocket.Connected)
            {
                StartClient();
            }

            cmd[0] = 3;
            for (i = 1; i < 20; ++i)
            {
                cmd[i] = 3;
            }
            
            try
            {
                RTCImgProc.Send(TCPsocket, cmd, 0, 20, 10000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
            }

            try
            {
                RTCImgProc.Receive(TCPsocket, recv, 0, 1440, 10000);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unexpected exception: {0}", ex.ToString());
            }

            for (i = 1; i < 4; ++i)
            {
                send[i] = 0;
            }

            TCPsocket.NoDelay = true;
            TCPsocket.ReceiveTimeout = 100;

            recvNotComplete = 0;

            for (t = 0; t < 1000000; ++t)
            {
                if (t % 10000 == 0)
                    Console.WriteLine("#" + t.ToString());

                recv_mem_size = 0;
                
                while (recv_mem_size < 1440)
                {
                    try
                    {
                        received = 0;
                        received = TCPsocket.Receive(recv, 1440 - recv_mem_size, SocketFlags.None);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                        break;
                    }

                    recv_mem_size += received;
                }

                if (recv_mem_size < 1440)
                {
                    recvNotComplete = 1;
                }

                while (recvNotComplete == 1)
                {
                    try
                    {
                        RTCImgProc.Send(TCPsocket, send, 0, 4, 10000);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                    }
                    
                    Console.WriteLine("[Info] recvNotComplete called");
                    while (recv_mem_size < 1440)
                    {
                        try
                        {
                            received = 0;
                            received = TCPsocket.Receive(recv, 1440 - recv_mem_size, SocketFlags.None);
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Unexpected exception: {0}", ex.ToString());
                            break;
                        }
                        recv_mem_size += received;

                        Console.WriteLine(received.ToString());
                    }
                    if (recv_mem_size == 1440)
                    {
                        recvNotComplete = 0;
                        Console.WriteLine("[Info] TCP receive recoverd");
                        
                    }
                }
            }
         
            MessageBox.Show("Download Complete");
        }
    }
}
