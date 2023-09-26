; A program to produce a big.in file which will result in a close encounter.
; This is only for CROSSING orbits only.



; Constants:

solarm = 1.98892d30
G = 6.67300d-11
pi = 3.14159265d0
AU = 149598000d3

; Planet values:               !!! We choose planet's a and planetesimal's e and masses

ap = 30.0
massp = 1.0e-5
masspsci = '1.0E-05'
rho = 4.0      ;density in g/cm^3

; Planetesimal values:
e = 0.0
tempe= 0.000000001
a = 67.5
peri = 80
f = 360-peri


oneEccen = TAN(f/2)
twoEccen = oneEccen/sqrt((1+e)/(1-e))
Eccen = 2*ATAN(twoEccen)

M = Eccen - (e*SIN(Eccen))



x = a-ap
absx = sqrt(x^2)

mass = 5.0e-10                 ;in solar masses
masssci = '5.0E-10'                   ;in quotations as scientific notation for fortran


u = G*(solarm + (mass*solarm))
timesec = 2*pi*SQRT((a*AU)^3/u)
time = timesec/(86400*365)

; Planet values:

up = G*(solarm + (massp*solarm))
timepsec = 2*pi*SQRT((ap*AU)^3/up)
timep = timepsec/(86400*365)


; Planet and dmin
ohmp = (2*pi)/timepsec
radius = ((massp*solarm/(rho*1000))*(3/(4*pi)))^(0.3333333333333d0)
ohm = (2*pi)/timesec
radiusau = radius/AU

bupper = sqrt((a-ap)^2) +(a*e)
blower = sqrt((a-ap)^2) - (a*e)

inttime = (ap/absx)*timep
rH = ap*((massp/3)^0.333333333d0)
vH = rH*(ohmp)
vu = a*ohm*tempe



OPENW, 3, '/home/hlau/mercury6/big.in'

text1 = ')O+_06 Big-body initial data  (WARNING: Do not delete this line!!)'
text2 = ') Lines beginning with ) are ignored.'
text3 = ')---------------------------------------------------------------------'
text4 = ' style (Cartesian, Asteroidal, Cometary) = Asteroid'
text5 = ' epoch (in days) = 0'
text6 = ')---------------------------------------------------------------------'



PRINTF, 3, text1
PRINTF, 3, text2
PRINTF, 3, text3
PRINTF, 3, text4
PRINTF, 3, text5
PRINTF, 3, text6
PRINTF, 3, FORMAT = '(%" PLANET    m=%s r=20.d0 d=%f")', masspsci, rho
PRINTF, 3, FORMAT = '(%" %fE+00 0.1E-04 0.0E+00")', ap
PRINTF, 3, FORMAT = '(%" 0.0E+00 0.0E+00 %fE+00")', 0.0
PRINTF, 3, FORMAT = '(%" %s %s %s")', '0.0E+00', '0.0E+00', '0.0E+00'
PRINTF, 3, FORMAT = '(%" LITTLE    m=%s r=20.d0 d=3.5")', masssci
PRINTF, 3, FORMAT = '(%" %fE+00 %fE+00 0.0E+00")', a, e      
PRINTF, 3, FORMAT = '(%" %fE+00 0.0E+00 %fE+00")',0,180.0;peri, M
PRINTF, 3, FORMAT = '(%" %s %s %s")', '0.0E+00', '0.0E+00', '0.0E+00'   

PRINT, " "
PRINT, "CALCULATION RESULTS:"
PRINT, " "
PRINT, "The radius of the planet is: ", radiusau, "AU"
PRINT, "The required impact parameter lies between: ", blower, "AU and ", bupper
PRINT, "If this is negative, change the mass of the planet or the density"
PRINT, "For a non crossing orbit, ae < |x|'
PRINT, "ae = ", a*e
PRINT, "x = ", absx 
PRINT, "encounter time is", (2/ohmp)/(86400*365), "years"
PRINT, "synodic period is", inttime
PRINT, "when x is small: predicted ap change =", (mass*massp*(ap^6))/(absx^5)
PRINT, "when x is large: predicted ap change =", (mass*(ap^4)*e)/(absx^3)
PRINT, "Hill radius = ", rH
PRINT, "x = ", a-ap
PRINT, "Upper bound of condition 1 (in paper) = ", rH*sqrt(vH/vu)


CLOSE, 3

file = '/home/hlau/mercury6/param.in'
OPENW, 2, file
PRINTF, 2, ')O+_06 Integration parameters  (WARNING: Do not delete this line!!)'
PRINTF, 2, ') Lines beginning with ) are ignored.'
PRINTF, 2, ')---------------------------------------------------------------------'
PRINTF, 2, ') Important integration parameters:'
PRINTF, 2, ')---------------------------------------------------------------------'
PRINTF, 2, ' algorithm (MVS, BS, BS2, RADAU, HYBRID etc) = BS'
PRINTF, 2, ' start time (days)= 0'
PRINTF, 2, FORMAT = '(%" stop time (days) = %d")', (inttime*365*1.5)+(timep*365)
PRINTF, 2, ' output interval (days) = 500d0'
PRINTF, 2, ' timestep (days) = 400'
PRINTF, 2, ' accuracy parameter=1.d-12'
PRINTF, 2, ')---------------------------------------------------------------------'
PRINTF, 2, ') Integration options:'
PRINTF, 2, ')---------------------------------------------------------------------'
PRINTF, 2, ' stop integration after a close encounter = no'
PRINTF, 2, ' allow collisions to occur = yes'
PRINTF, 2, ' include collisional fragmentation = no'
PRINTF, 2, ' express time in days or years = years'
PRINTF, 2, ' express time relative to integration start time = yes'
PRINTF, 2, ' output precision = high'
PRINTF, 2, ' < not used at present >'
PRINTF, 2, ' include relativity in integration= no'
PRINTF, 2, ' include user-defined force = no'
PRINTF, 2, ')---------------------------------------------------------------------'
PRINTF, 2, ') These parameters do not need to be adjusted often:'
PRINTF, 2, ')---------------------------------------------------------------------'
PRINTF, 2, ' ejection distance (AU)= 100'
PRINTF, 2, ' radius of central body (AU) = 0.005'
PRINTF, 2, ' central mass (solar) = 1.0'
PRINTF, 2, ' central J2 = 0'
PRINTF, 2, ' central J4 = 0'
PRINTF, 2, ' central J6 = 0'
PRINTF, 2, ' < not used at present >'
PRINTF, 2, ' < not used at present >'
PRINTF, 2, ' Hybrid integrator changeover (Hill radii) = 20.0'
PRINTF, 2, ' number of timesteps between data dumps = 300'
PRINTF, 2, ' number of timesteps between periodic effects = 100'

CLOSE, 2

;NC details






OPENW, 4, '/home/hlau/NC_encounters/NCinfo.txt'

PRINTF, 4, "a = ", a
PRINTF, 4, "e = ", e
PRINTF, 4, "ap = ", ap
PRINTF, 4, "planet mass = ", massp
PRINTF, 4, "planetesimal mass = ", mass
PRINTF, 4, "Hill radius = ", rH
PRINTF, 4, "x = ", a-ap
PRINTF, 4, "Upper bound of condition 1 (in paper) = ", rH*sqrt(vH/vu)
PRINTF, 4, " "
PRINTF, 4, FORMAT = '(%"%f %f %f %e %e %f %f %f")', a, e, ap, massp, mass, rH ,$
a-ap, rH*sqrt(vH/vu)

CLOSE, 4
