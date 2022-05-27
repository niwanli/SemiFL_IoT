## Semi-Federated Learning for Collaborative Intelligence in Massive IoT Networks

**Note:** All code and data are used for the following ACM SIGCOMM 2022 poster paper:
> **Title:** Semi-Federated Learning for Collaborative Intelligence in Massive IoT Networks
>
> **Author:** Wanli Ni, Jingheng Zheng, and Hui Tian
>
> **Institution:**  Beijing University of Posts and Telecommunications

In this paper, we propose a novel semi-federated learning (SemiFL) concept that seamlessly integrates the conventional centralized learning and federated learning into a harmonized framework.

### Citation

```
@inproceedings{Ni2022Semi,
    author = {Ni, Wanli and Zheng, Jingheng and Tian, Hui},
    title = {Semi-Federated Learning for Collaborative Intelligence in Massive IoT Networks},
    booktitle = {SIGCOMM'21 Poster and Demo Sessions (SIGCOMM21 Demos and Posters)},
    year = {2022},
    month = {August},
    note = {under review}
}
```

### Directory Structure

```
code/
	├── Fashion_MNIST/
		├── dataset pre-processing tools/
		├── non_iid_labels.mat
		├── non_iid_samples.mat
		├── test_data_all.mat
		├── test_label_all.mat
		├── train_data_all.mat
		├── train_label_all.mat
	├── centralized_learning.m
	├── federated_learning.m
	├── semi_federated_learning_ideal.m
	├── semi_federated_learning.m
	├── get_selected_CL_devices.m
	├── get_selected_FL_devices.m
	├── get_locations.m
	├── get_channels.m
	├── get_gradient.m
	├── get_pruned_model.m
	├── get_initial_model.mat
	└── performance_vs_rounds/
data/
	├── CL_without_sampling.mat
	├── FL_with_pruning.mat
	├── SemiFL_without_sampling_and_pruning.mat
	├── SemiFL_with_sampling_and_pruning.mat
	├── draw_accuracy.m
	└── draw_loss.m	
```
