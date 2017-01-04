# mr2ct
This project is to predict CT from MRI volume-to-volume. In this project, euclidean loss and approximate L1 loss is used. Also, deeply supervised nets (DSN) are used to help train the nets. Auto context model (ACM) is also employed to refine the results.

1. prostate_train_test_dsn_v2.prototxt: the dsn version of network prototxt file.

2. prostate_train_test_acm_bn.prototxt: the autocontext refinement version (also with dsn) of network prototxt file.

If you find it is helpful for your work, please cite:

"Nie, Dong, et al. "Estimating CT Image from MRI Data Using 3D Fully Convolutional Networks." International Workshop on Large-Scale Annotation of Biomedical Data and Expert Label Synthesis. Springer International Publishing, 2016."

Actually, I remove the DSN and ACM part, as it is a workshop paper and have page limitation. But the code/prototxt provided contains the DSN and ACM part.

