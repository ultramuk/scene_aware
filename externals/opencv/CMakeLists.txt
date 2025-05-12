add_external_package(
    VERSION 4.5.5
    DESCRIPTION "Open Source Computer Vision Library"
    REPOSITORY_URL "https://github.com/opencv/opencv.git"
    REPOSITORY_TAG "4.5.5"
    COMPILE_ARGUMENTS
        -DWITH_CUDA=ON
        -DWITH_TBB=ON
        -DBUILD_TESTS=OFF
        -DBUILD_PERF_TESTS=OFF
        -DBUILD_opencv_python=OFF
        -DWITH_QT=OFF
        -DWITH_GTK=OFF
    LIBRARIES opencv_core opencv_imgproc opencv_highgui opencv_videoio
)
