
#' Mathematical Modeling of Infectious Disease Dynamics
#'
#' \tabular{ll}{
#'    Package: \tab EpiModel\cr
#'    Type: \tab Package\cr
#'    Version: \tab 1.7.5\cr
#'    Date: \tab 2019-09-05\cr
#'    License: \tab GPL-3\cr
#'    LazyLoad: \tab yes\cr
#' }
#'
#' @details
#' The EpiModel software package provides tools for building, solving, and
#' visualizing mathematical models of infectious disease dynamics. These tools allow users
#' to simulate epidemic models in multiple frameworks for both pedagogical
#' purposes ("base models") and novel research purposes ("extension models").
#'
#' @section Model Classes and Infectious Disease Types:
#' EpiModel provides functionality for three classes of epidemic models:
#' \itemize{
#'  \item \strong{Deterministic Compartmental Models:} these continuous-time
#'        models are solved using ordinary differential equations. EpiModel
#'        allows for easy specification of sensitivity analyses to compare multiple
#'        scenarios f the same model across different parameter values.
#'  \item \strong{Stochastic Individual Contact Models:} a novel class of
#'        individual-based, microsimulation models that were developed to add
#'        random variation in all components of the transmission system, from
#'        infection to recovery to vital dynamics (arrivals and departures).
#'  \item \strong{Stochastic Network Models:} with the underlying statistical
#'        framework of temporal exponential random graph models (ERGMs) recently
#'        developed in the \strong{Statnet} suite of software in R, network
#'        models over epidemics simulate edge (e.g., partnership) formation and
#'        dissolution stochastically according to a specified statistical model,
#'        with disease spread across that network.
#'  }
#'
#' EpiModel supports three infectious disease types to be run across all of the
#' three classes.
#'  \itemize{
#'   \item \strong{Susceptible-Infectious (SI):} a two-state disease in which
#'         there is life-long infection without recovery. HIV/AIDS is one example,
#'         although for this case it is common to model infection stages as
#'         separate compartments.
#'   \item \strong{Susceptible-Infectious-Recovered (SIR):} a three-stage disease
#'         in which one has life-long recovery with immunity after infection.
#'         Measles is one example, but modern models for the disease also require
#'         consideration of vaccination patterns in the population.
#'   \item \strong{Susceptible-Infectious-Susceptible (SIS):} a two-stage disease
#'         in which one may transition back and forth from the susceptible to
#'         infected states throughout life. Examples include bacterial sexually
#'         transmitted diseases like gonorrhea.
#'  }
#' These basic disease types may be extended in any arbitrarily complex way to
#' simulate specific diseases for research questions.
#'
#' @section Model Parameterization and Simulation:
#' EpiModel uses three model setup functions for each model class to input the
#' necessary parameters, initial conditions, and control settings:
#' \itemize{
#'  \item \code{\link{param.dcm}}, \code{\link{param.icm}}, and
#'        \code{\link{param.net}} are used to input epidemic parameters for each
#'        of the three model classes. Parameters include the rate of contacts or
#'        acts between actors, the probability of transmission per contact, and
#'        recovery and demographic rates for models that include those transitions.
#'  \item \code{\link{init.dcm}}, \code{\link{init.icm}}, and \code{\link{init.net}}
#'        are used to input the initial conditions for each class. The main
#'        conditions are limited to the numbers or, if applicable, the specific
#'        agents in the population who are infected or recovered at the simulation
#'        outset.
#'  \item \code{\link{control.dcm}}, \code{\link{control.icm}}, and
#'        \code{\link{control.net}} are used to specify the remaining control
#'        settings for each simulation. The core controls for base model
#'        types include the disease type, number of time steps, and number of
#'        simulations. Controls are also used to input new model functions (for
#'        DCMs) and new model modules (for ICMs and network models) to allow the
#'        user to simulate fully original epidemic models in EpiModel. See the
#'        documention for the specific control functions help pages.
#' }
#'
#' With the models parameterized, the functions for simulating epidemic models are:
#' \itemize{
#'  \item \code{\link{dcm}} for deterministic compartmental models.
#'  \item \code{\link{icm}} for individual contact models.
#'  \item Network models are simulated in a three-step process:
#'  \enumerate{
#'    \item \code{\link{netest}} estimates the statistical model for the network
#'          structure itself (i.e., how partnerships form and dissolve over time
#'          given the parameterization of those processes). This function is a wrapper
#'          around the \code{ergm} and \code{stergm} functions in the \code{ergm}
#'          and \code{tergm} packages. The current statistical framework for model
#'          simulation is called "egocentric inference": target statistics summarizing
#'          these formation and dissolution processes collected from an egocentric
#'          sample of the population.
#'    \item \code{\link{netdx}} runs diagnostics on the dynamic model fit by
#'          simulating the base network over time to ensure the model fits the
#'          targets for formation and dissolution.
#'    \item \code{\link{netsim}} simulates the stochastic network epidemic models,
#'          with a given network model fit in \code{\link{netest}}. Here the
#'          function requires this model fit object along with the parameters,
#'          initial conditions, and control settings as defined above.
#'  }
#' }
#'
#' @references
#' The EpiModel website is at \url{http://epimodel.org/}, and the source
#' code is at \url{http://github.com/statnet/EpiModel}. Bug reports and feature
#' requests are welcome there.
#'
#' Our primary methods paper on EpiModel is published in the \strong{Journal of Statistical Software}.
#' If you use EpiModel for any research or teaching purposes, please cite this reference:
#'
#' Jenness SM, Goodreau SM and Morris M. EpiModel: An R Package for Mathematical
#' Modeling of Infectious Disease over Networks. Journal of Statistical Software.
#' 2018; 84(8): 1-47. doi: 10.18637/jss.v084.i08 (\url{http://doi.org/10.18637/jss.v084.i08}).
#'
#' We have also developed an extension package specifically for modeling HIV and related
#' sexually transmitted infections, called \code{EpiModelHIV} and available on Github
#' at \url{http://github.com/statnet/EpiModelHIV}.
#'
#' @name EpiModel-package
#' @aliases EpiModel
#' @import ergm network networkDynamic tergm ggplot2
#' @importFrom deSolve dede ode
#' @importFrom doParallel registerDoParallel
#' @importFrom foreach foreach "%dopar%"
#' @importFrom RColorBrewer brewer.pal brewer.pal.info
#' @importFrom graphics abline arrows boxplot legend lines mtext par plot points
#'             polygon text title
#' @importFrom grDevices col2rgb colorRampPalette rgb adjustcolor
#' @importFrom stats complete.cases quantile rbinom rgeom sd setNames simulate
#'             supsmu terms.formula update
#' @importFrom utils head tail packageVersion
#' @importFrom ape as.phylo collapse.singles
#' @importFrom lazyeval lazy_dots lazy_eval
#'
#' @useDynLib EpiModel, .registration = TRUE
#'
#' @docType package
#' @keywords package
#'
NULL
