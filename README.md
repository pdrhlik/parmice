# parmice
R package that speeds up **multiple imputation** very easily. You should be familiar with the [`mice`](https://github.com/stefvanbuuren/mice) package in order to use `parmice`.

Multiple imputation is a great example of a method that can be processed in parallel. The whole process consists of creating several data sets with imputed values. Each of the data sets is created **independently** - it doesn't matter in which order we create them. We can therefore create them in parallel.

## Installation
You can install the package using [devtools](https://github.com/hadley/devtools):
```
devtools::install_github("pdrhlik/parmice")
```

## Usage
The easiest way to use parmice is as easy as:
```
imp <- parmice(data)
```

You can supply `parmice` the same arguments you would put in the `mice` call. The only argument that is new in `parmice` is `ncores`. This argument accepts a number of cores that will be used in the imputation process. It is set to the *number of cores of your computer minus one* by default. The number of cores are detected using the `detectCores()` function from the `parallel` package.

The number of imputed dataset will not always equal to `m`. That's because it depends on `ncores`. Each core will process exactly `ceiling(m / ncores)` which means that the total number of imputed datasets will be `ncores * ceiling(m / ncores)`. That's because we want all the cores to work equally. It is therefore recommended that `m` should always be a multiple of `ncores`.

**Remember that `m == 5` by default!**

### Examples
`m == ncores`: Number of imputed data sets will be `5 * ceiling(5 / 5) == 5`
```
imp <- parmice(data, ncores = 5, m = 5)
```

`m > ncores`: Number of imputed data sets will be `5 * ceiling(6 / 5) == 10`
```
imp <- parmice(data, ncores = 5, m = 6)
```

`m < ncores`: Number of imputed data sets will be `5 * ceiling(4 / 5) == 5`
```
imp <- parmice(data, ncores = 5, m = 4)
```

## Performace comparison with mice
Graphs will be presented soon.

## Author
**Patrik Drhlik** - *Initial work* - [pdrhlik](https://github.com/pdrhlik)

Don't hesitate to contribute if you have any ideas on how to fix or improve the package.

## License
This project is licensed under the GPL-3 License.

## Acknowledgments
This project wouldn't be possible without the following parties:
* The University of Queensland, Australia
* Technical University of Liberec, Czech Republic
* NESSIE Erasmus Mundus project
