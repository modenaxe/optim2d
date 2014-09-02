% This file documents the use of the MEX function gait2d.mex32

% The musculoskeletal model is documented in the file gait2d_reference.pdf

% The MEX function can be used to perform several functions with the model.

function [] = gait2d('Initialize', par)
% This initializes the model with a set of parameters.  This is required before anything is
% done with the model.  The par matrix can be obtained by reading an Excel file:
%		par = readxls('gait2d_par.xls);
% The Excel file also contains labels to facilitate human reading and editing.

function [f, dfdx, dfdxdot, dfdu, dfdM] = gait2d('Dynamics',x,xdot,u,M);

% Implicit differential equation for 2D musculoskeletal model : f(x,dx/dt,u) = 0

% Input:
%	x			State of the model (50 x 1)
%   xdot		State derivatives (50 x 1)
%   u			Neural excitations for the muscles (16 x 1)
%	M			(optional) Extra joint moments (6 x 1), for instance from prosthetic device

% Output:
%	f			Dynamic residuals (50 x 1), zeros are returned when inputs satisfy system dynamics 
%	dfdx		(optional) Jacobian matrix df/dx (50 x 50)
%	dfdxdot		(optional) Jacobian matrix df/dxdot (50 x 50)
%	dfdu		(optional) Jacobian matrix df/du (50 x 16)
%   dfdM		(optional) Jacobian matrix df/dM (50 x 6)

% The last three outputs are optional and some computation time is saved if you do 
% not request all of them.

% States are:
%	x(1)		X coordinate of trunk center of mass (m)
%	x(2)		Y coordinate of trunk center of mass (m)
%	x(3)		orientation of trunk (rad), zero when standing upright
%	x(4)		right hip angle (rad), zero when standing, positive for flexion
%	x(5)		right knee angle (rad), zero when standing, positive for hyperextension
%	x(6)		right ankle angle (rad), zero when standing, positive for dorsiflexion
%	x(7-9)		left side hip, knee and ankle angles (rad)
%	x(10-18)	generalized velocities, i.e. time derivatives of x(1-9)
%	x(19-34)	contractile element (CE) lengths of the muscles, relative to Lceopt
%	x(35-50)	active states of the muscles

% Muscles are listed in gait2d_par.xls.

function [grf, dgrfdx] = gait2d('GRF', x)
% This returns the ground reaction forces for the system in state x
% 
% Output:
%	grf			4 x 1 matrix, Right Fx, Fy, Left Fx,Fy
%	dgrfdx		(optional) 4 x 50 matrix, derivatives of grf with respect to state x

function [stick] = gait2d('Stick', x)
% This returns data for a stick figure, for the system in state x
% 
% Output:
%	stick	10 x 2 matrix, containing x and y coordinates for 10 points.
% The stick figure points are:
%	1		Trunk center of mass
%	2		Hip joint
%	3,4		Right knee and ankle
%	5,6		Right heel and toe
%	7-8		Left knee and ankle
% 	9-10	Left heel and toe	

function [forces] = gait2d('Muscleforces', x)
% This returns muscle forces, for the system in state x
% 
% Output:
%	forces		16 x 1 column vector with muscle forces (N), in same order as muscle table in gait2d_par.xls

function [powers] = gait2d('MuscleCEpower', x, xdot)
% This returns power generated by muscle contractile elements, for the system in state x
% xdot must be the state derivatives, such that the muscle balance equations are satisfied
% 
% Output:
%	powers		16 x 1 column vector with CE power output (W), in same order as muscle table in gait2d_par.xls

function [moments] = gait2d('Jointmoments', x)
% This returns joint moments, for the system in state x
% 
% Output:
%	moments		6 x 1 column vector with joint moments in order:
%				right hip, knee, ankle, left hip, knee, ankle

function [par] = gait2d('Get',name);
% To extract values of model parameters.
% The following "name" arguments are presently available, and produce these outputs
% 	'Lceopt' 			16 x 1 vector (m), optimal contractile element (CE) length
%   'Total Mass'		scalar (kg), total body mass of the model

function gait2d('Set',name,par);
% To set values of model parameters
% The following "name,par" arguments are presently available
% 	'Extra Mass' 		1x4 vector: segment, mass, X, Y
%						Segment 0 adds mass to trunk, 1 adds the mass to each thigh, 2 is shanks, 3 feet

