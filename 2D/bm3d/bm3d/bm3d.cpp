#include "pch.h"
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/photo/photo.hpp>
#include <math.h>

using namespace cv;
using namespace std;

int main()
{
	//Load an Image
	Mat img = imread("C:\\image2.jpg", CV_LOAD_IMAGE_COLOR);
	namedWindow("Image", CV_WINDOW_AUTOSIZE);
	imshow("Image", img);


	//Blur Effect
	GaussianBlur(img, img, cv::Size(3, 3), 0);
	cv::xphoto::bm3dDenoising(img, img);  // ???? 

	namedWindow("Output", CV_WINDOW_AUTOSIZE);
	imshow("Output", img);

	//Wait Key press
	cvWaitKey(0);

	//destroy
	cvDestroyWindow("Image");
	cvDestroyWindow("BlurEffect");

	return 0;
}