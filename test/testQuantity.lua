--[[
This file contains the unit tests for the physical.Quantity class.

Copyright (c) 2017 Thomas Jenni (tjenni@me.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local lu = require("luaunit")

package.path = "../?.lua;" .. package.path
local physical = require("physical")

local N = physical.Number

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         if getmetatable(v) == physical.Unit then
            s = s .. '['..k..'] = ' .. v.symbol .. ','
         else
           s = s .. '['..k..'] = ' .. dump(v) .. ','
         end
      end
      return s .. '}\n'
   else
      return tostring(o)
   end
end


TestQuantity = {}

function TestQuantity.addError()
   local l = 5*_m + 10*_s
end
function TestQuantity:testAdd()
   local l = 5*_m + 10*_m
   lu.assertEquals( l.value, 15 )
   lu.assertEquals( l.dimension, _m.dimension )

   lu.assertError( addError )
end


function TestQuantity.subtractError()
   local l = 5*_m - 10*_s
end
function TestQuantity:testSubtract()
   local l = 5*_m - 15*_m
   lu.assertEquals( l.value, -10 )
   lu.assertEquals( l.dimension, _m.dimension )

   lu.assertError( subtractError )
end


function TestQuantity:testUnaryMinus()
   local l = -5*_m
   lu.assertEquals( l.value, -5 )
   lu.assertEquals( l.dimension, _m.dimension )
end


function TestQuantity:testMultiply()
   local A = 5*_m * 10 * _m
   lu.assertEquals( A.value, 50 )
   lu.assertEquals( A.dimension, (_m^2).dimension )
end


function TestQuantity.divideError()
   local l = 7*_m / ((2*6 - 12)*_s)
end
function TestQuantity:testDivide()
   local v = 7*_m / (2*_s)
   lu.assertEquals( v.value, 3.5 )
   lu.assertEquals( v.dimension, (_m/_s).dimension )

   lu.assertError( divideError )
end

-- test power function
function TestQuantity:testPow()
   local V = (5*_m)^3
   lu.assertEquals( V.value, 125 )
   lu.assertEquals( V.dimension, (_m^3).dimension )
end

function TestQuantity:testPowWithQuantityAsExponent()
   local V = (5*_m)^(24*_m / (12*_m))
   lu.assertAlmostEquals( V.value, 25, 0.00001 )
   lu.assertEquals( V.dimension, (_m^2).dimension )
end

-- test isclose function
function TestQuantity:testisclose()
   local rho1 = 19.3 * _g / _cm^3
   local rho2 = 19.2 * _g / _cm^3

   lu.assertTrue( rho1:isclose(rho2,0.1) )
end

-- test absolute value function
function TestQuantity:testAbs()
   local l = (-45.3 * _m):abs()
   lu.assertEquals( l.value, 45.3 )
   lu.assertEquals( l.dimension, _m.dimension )

   local l = (N(-233,3) * _m^2):abs()
   lu.assertEquals( l.value, N(233,3) )
   lu.assertEquals( l.dimension, (_m^2).dimension )
end

-- test square root function
function TestQuantity:testSqrt()
   local l = (103 * _cm^2):sqrt()
   lu.assertEquals( l.value, 10.148891565092219 )
   lu.assertEquals( l.dimension, _m.dimension )

   local l = (N(103,2) * _cm^2):sqrt()
   lu.assertAlmostEquals( l.value._x, 10.148891565092219, 0.0001 )
   lu.assertAlmostEquals( l.value._dx, 0.098532927816429, 0.0001 )
   lu.assertEquals( l.dimension, _m.dimension )
end

-- test logarithm function
function TestQuantity.logError()
   local l = (100 * _s):log()
end
function TestQuantity:testLog()
   lu.assertError( logError )

   local l = (100 * _1):log()
   lu.assertAlmostEquals( l.value, 4.605170185988091, 0.0001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = (600 * _m / (50000 * _cm)):log()
   lu.assertAlmostEquals( l.value, 0.182321556793955, 0.0001 )
   lu.assertEquals( l.dimension, _1.dimension )

   local l = ( N(100,0) * _1 ):log()
   lu.assertAlmostEquals( l.value._x, 4.605170185988091, 0.0001 )
   lu.assertEquals( l.dimension, _1.dimension )
end

-- test exponential function
function TestQuantity.expError()
   local l = (100 * _s):log()
end
function TestQuantity:testExp()
   lu.assertError( expError )

   local l = (-2*_m/(5*_m)):exp()
   lu.assertAlmostEquals( l.value, 0.670320046035639, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )
end

-- test sine function
function TestQuantity.sinError()
   local l = (100 * _s):sin()
end
function TestQuantity:testSin()
   lu.assertError( sinError )

   local l = (45 * _deg):sin()
   lu.assertAlmostEquals( l.value, 0.707106781186548, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )
end

-- test cosine function
function TestQuantity.cosError()
   local l = (100 * _s):cos()
end
function TestQuantity:testCos()
   lu.assertError( cosError )

   local l = (50 * _deg):cos()
   lu.assertAlmostEquals( l.value, 0.642787609686539, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )
end

-- test tangens function
function TestQuantity.tanError()
   local l = (100 * _s):tan()
end
function TestQuantity:testTan()
   lu.assertError( tanError )
   
   local l = (50 * _deg):tan()
   lu.assertAlmostEquals( l.value, 1.19175359259421, 0.000001 )
   lu.assertEquals( l.dimension, _1.dimension )
end


-- test asin function
function TestQuantity.asinError()
   local l = (100 * _s):asin()
end
function TestQuantity:testAsin()
   lu.assertError( asinError )

   local l = (0.5 * _1):asin()
   lu.assertAlmostEquals( l.value, 0.523598775598299, 0.000001 )
   lu.assertEquals( l.dimension, _rad.dimension )
end


-- test acos function
function TestQuantity.acosError()
   local l = (100 * _s):acos()
end
function TestQuantity:testAcos()
   lu.assertError( acosError )

   local l = (0.5 * _1):acos()
   lu.assertAlmostEquals( l.value, 1.047197551196598, 0.000001 )
   lu.assertEquals( l.dimension, _rad.dimension )
end


-- test atan function
function TestQuantity.atanError()
   local l = (100 * _s):atan()
end
function TestQuantity:testAtan()
   lu.assertError( atanError )

   local l = (0.5 * _1):atan()
   lu.assertAlmostEquals( l.value, 0.463647609000806, 0.000001 )
   lu.assertEquals( l.dimension, _rad.dimension )
end


return TestQuantity
