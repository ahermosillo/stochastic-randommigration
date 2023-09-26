; A program to produce a big.in file which will result in a close encounter.
; This is only for CROSSING orbits only.


; When do you want the bodies to encounter each other? (in years)
clotime = 2.5


; Constants:

solarm = 1.98892d30
G = 6.67300d-11
pi = 3.14159265d0
AU = 149598000d3


; Planetesimal values:

a = 25.0d0                               ;in AU
e = 0.4
mass = 1.0d-10                      ;in solar masses
masssci = '1.0E-10'                 ;in quotations as scientific notation for fortran



; Planet values:

ap =  28.0d0
massp = 1.0d-5
masspsci = '1.0E-05'
rho = 4.0      ;density in g/cm^3


;Finding common angle
onef =  (a*(1-(e^2)))/ap
twof = (onef-1)/e
f = ACOS(twof)


;Calculations for planetesimal
oneEccen = TAN(f/2)
twoEccen = oneEccen/sqrt((1+e)/(1-e))
Eccen = 2*ATAN(twoEccen)

M = Eccen - (e*SIN(Eccen))


u = G*(solarm + (mass*solarm))
timesec = (2*pi*SQRT(((a*AU)^3)/u))
time = timesec/(86400*365)


;Calculations for planet
up = G*(solarm + (massp*solarm))
timep = (2*pi*SQRT(((ap*AU)^3)/up))/(86400*365)


;Calculations for collision

deltaM = (2*pi/time)*clotime
deltaMp = (2*pi/timep)*clotime
print, M
print, deltaM

start1 = (M - deltaM)*180/pi
startp = (f - deltaMp)*180/pi


ohm = (2*pi)/timesec


radius = ((massp*solarm/(rho*1000))*(3/(4*pi)))^(0.333333d0)
radiusau = radius/AU
dmax = ((G*massp*solarm)/(a*AU*e*ohm)^2)/AU


; Offset of planetesimal.

r = a*(1-e*COS(Eccen))
delf1 = (2*r^2-(dmax)^2)/(2*r^2)
delf = ACOS(delf1)
newEccen1 = TAN((f-delf)/2)
newEccen2 = newEccen1/sqrt((1+e)/(1-e))
newEccen = 2*ATAN(newEccen2)



start = start1-0.01
;start = start1 -(delf*180/pi)

cirrange, start
cirrange, startp

xpoint1 = ap*COS(f)
ypoint1 = ap*SIN(f)
xpoint2 = a*(COS(newEccen)-e) 
ypoint2 = a*SIN(newEccen)*SQRT(1-(e^2))


;Producing the big.in file

fname = '/home/hlau/mercury6/big.in'

OPENW, 3, fname

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
PRINTF, 3, FORMAT = '(%" PLANET    m=%s r=1.d0 d=%f")', masspsci, rho
PRINTF, 3, FORMAT = '(%" %fE+00 0.1E-04 0.0E+00")', ap
PRINTF, 3, FORMAT = '(%" 0.0E+00 0.0E+00 %fE+00")', startp
PRINTF, 3, FORMAT = '(%" %s %s %s")', '0.0E+00', '0.0E+00', '0.0E+00'
PRINTF, 3, FORMAT = '(%" LITTLE    m=%s r=1.d0 d=3.5")', masssci
PRINTF, 3, FORMAT = '(%" %fE+00 %fE+00 0.0E+00")', a, e      
PRINTF, 3, FORMAT = '(%" 0.0E+00 0.0E+00 %fE+00")', start
PRINTF, 3, FORMAT = '(%" %fE+00 %fE+00 %fE+00")', 0.0, 0.0,0.0   

CLOSE, 3

PRINT, " "
PRINT, "CALCULATION RESULTS:"
PRINT, " "
PRINT, "The angles where they encounter are:"
PRINT, "Planet at M=", f*(180/pi), " degrees"
PRINT, "Planetesimal at M=", M*(180/pi), " degrees"
PRINT, " "

PRINT, "The radius of the planet is: ", radiusau, "AU"
PRINT, "The required impact parameter is: ", dmax, "AU"
PRINT, "The maximum dmin value for a close encounter is:", dmax-radiusau, "AU"
PRINT, "If this is negative, change the mass of the planet or the density"



file = '/home/hlau/mercury6/param.in'
OPENW, 2, file
PRINTF, 2, ')O+_06 Integration parameters  (WARNING: Do not delete this line!!)'
PRINTF, 2, ') Lines beginning with ) are ignored.'
PRINTF, 2, ')---------------------------------------------------------------------'
PRINTF, 2, ') Important integration parameters:'
PRINTF, 2, ')---------------------------------------------------------------------'
PRINTF, 2, ' algorithm (MVS, BS, BS2, RADAU, HYBRID etc) = hyb'
PRINTF, 2, ' start time (days)= 0'
PRINTF, 2, FORMAT = '(%" stop time (days) = %d")', (clotime*365)*3
PRINTF, 2, ' output interval (days) = 5d0'
PRINTF, 2, ' timestep (days) = 3'
PRINTF, 2, ' accuracy parameter=1.d-12'
PRINTF, 2, ')---------------------------------------------------------------------'
PRINTF, 2, ') Integration options:'
PRINTF, 2, ')---------------------------------------------------------------------'
PRINTF, 2, ' stop integration after a close encounter = no'
PRINTF, 2, ' allow collisions to occur = yes'
PRINTF, 2, ' include collisional fragmentation = no'
PRINTF, 2, ' express time in days or years = years'
PRINTF, 2, ' express time relative to integration start time = no'
PRINTF, 2, ' output precision = medium'
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
PRINTF, 2, ' Hybrid integrator changeover (Hill radii) = 1.0'
PRINTF, 2, ' number of timesteps between data dumps = 300'
PRINTF, 2, ' number of timesteps between periodic effects = 100'

CLOSE, 2

fn = 'encounterpositions.txt'

OPENW, 33, fn

PRINTF, 33, FORMAT = '(%"%f %f")', xpoint1,ypoint1
PRINTF, 33, FORMAT = '(%"%f %f")', xpoint2,ypoint2

CLOSE, 33



OPENW, 4, '/home/hlau/C_encounters/Cinfo.txt'

PRINTF, 4, "a = ", a
PRINTF, 4, "e = ", e               
PRINTF, 4, "ap = ", ap
PRINTF, 4, "planet mass = ", massp
PRINTF, 4, "planetesimal mass = ", mass      
PRINTF, 4, "Impact parameter,b =", dmax
PRINTF, 4, FORMAT = '(%"%f %f %f %e %e %f")', a, e, ap, massp, mass, dmax

CLOSE, 4
