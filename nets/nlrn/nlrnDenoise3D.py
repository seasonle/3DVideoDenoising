import h5py as h5py

with h5py.File("../../data/qrm2.mat", 'r') as file:
    data3 = list(file['data3']);



print(data3[100]);