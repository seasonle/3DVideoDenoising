% Install and compile MatConvNet (needed once).
untar('http://www.vlfeat.org/matconvnet/download/matconvnet-1.0-beta25.tar.gz') ;
cd matconvnet-1.0-beta25

vl_compilenn('enableGpu',true,'cudaRoot','C:/CUDA','cudaMethod','nvcc');