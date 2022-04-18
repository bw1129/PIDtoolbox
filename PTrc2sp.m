% PTrc2sp()

% from emuflight

function [RCcommand_dps] = PTrc2sp(RCcommand, rateSystem)
%function [RCcommand_dps] = PTrc2sp(RCcommand)
%   converts rc command to deg/s

BetaflightRates = 1;
BFActualRates = 2;

EmuflightRates = 2;

    rcCommandf    = RCcommand / 500.0;
    rcCommandfAbs = abs(rcCommandf);

          %  if rc_expo 
                expof = rc_expo / 100;
                rcCommandf = rcCommandf * Math.pow(rcCommandfAbs, RC_EXPO_POWER) * expof + rcCommandf * (1-expof);
          %  end

            rcRate = rc_rates / 100.0;
          %  if (rcRate > 2.0)  
                rcRate += RC_RATE_INCREMENTAL * (rcRate - 2.0);
          %  end

            angleRate = 200.0 * rcRate * rcCommandf;
         %   if rates 
                rcSuperfactor = 1.0 / ((1.0 - (rcCommandfAbs * rates / 100.0)));
                angleRate = angleRate * rcSuperfactor;
         %   end

 return calculateSetpointRate(axis, value);


%%%%% From betaflight configurator RC3


 const minRc = 1000;
const midRc = 1500;
const maxRc = 2000;

const RateCurve = function (useLegacyCurve) {
    this.useLegacyCurve = useLegacyCurve;
    this.maxAngularVel = null;

    this.constrain = function (value, min, max) {
        return Math.max(min, Math.min(value, max));
    };

    this.rcCommand = function (rcData, rcRate, deadband) {
        const tmp = Math.min(Math.max(Math.abs(rcData - midRc) - deadband, 0), 500);

        let result = tmp * rcRate;

        if (rcData < midRc) {
            result = -result;
        }

        return result;
    };

   
   
  
    this.getBetaflightRates = function (rcCommandf, rcCommandfAbs, rate, rcRate, rcExpo, superExpoActive, limit) {
        let angularVel;

        if (rcRate > 2) {
            rcRate = rcRate + (rcRate - 2) * 14.54;
        }

        let expoPower;
        let rcRateConstant;

        if (semver.gte(FC.CONFIG.apiVersion, "1.20.0")) {
            expoPower = 3;
            rcRateConstant = 200;
        } else {
            expoPower = 2;
            rcRateConstant = 205.85;
        }

        if (rcExpo > 0) {
            rcCommandf =  rcCommandf * Math.pow(rcCommandfAbs, expoPower) * rcExpo + rcCommandf * (1-rcExpo);
        }

        if (superExpoActive) {
            const rcFactor = 1 / this.constrain(1 - rcCommandfAbs * rate, 0.01, 1);
            angularVel = rcRateConstant * rcRate * rcCommandf; // 200 should be variable checked on version (older versions it's 205,9)
            angularVel = angularVel * rcFactor;
        } else {
            angularVel = (((rate * 100) + 27) * rcCommandf / 16) / 4.1; // Only applies to old versions ?
        }

        angularVel = this.constrain(angularVel, -1 * limit, limit); // Rate limit from profile

        return angularVel;
    };

    this.getRaceflightRates = function (rcCommandf, rate, rcRate, rcExpo) {
        let angularVel = ((1 + 0.01 * rcExpo * (rcCommandf * rcCommandf - 1.0)) * rcCommandf);
        angularVel = (angularVel * (rcRate + (Math.abs(angularVel) * rcRate * rate * 0.01)));
        return angularVel;
    };

    this.getKISSRates = function (rcCommandf, rcCommandfAbs, rate, rcRate, rcExpo) {
        const kissRpy = 1 - rcCommandfAbs * rate;
        const kissTempCurve = rcCommandf * rcCommandf;
        rcCommandf = ((rcCommandf * kissTempCurve) * rcExpo + rcCommandf * (1 - rcExpo)) * (rcRate / 10);
        return ((2000.0 * (1.0 / kissRpy)) * rcCommandf);
    };

    this.getActualRates = function (rcCommandf, rcCommandfAbs, rate, rcRate, rcExpo) {
        let angularVel;
        const expof = rcCommandfAbs * ((Math.pow(rcCommandf, 5) * rcExpo) + (rcCommandf * (1 - rcExpo)));

        angularVel = Math.max(0, rate-rcRate);
        angularVel = (rcCommandf * rcRate) + (angularVel * expof);

        return angularVel;
    };

    this.getQuickRates = function (rcCommandf, rcCommandfAbs, rate, rcRate, rcExpo) {
        rcRate = rcRate * 200;
        rate = Math.max(rate, rcRate);

        let angularVel;
        const superExpoConfig = (((rate / rcRate) - 1) / (rate / rcRate));
        const curve = Math.pow(rcCommandfAbs, 3) * rcExpo + rcCommandfAbs * (1 - rcExpo);

        angularVel = 1.0 / (1.0 - (curve * superExpoConfig));
        angularVel = rcCommandf * rcRate * angularVel;

        return angularVel;
    };

};

RateCurve.prototype.rcCommandRawToDegreesPerSecond = function (rcData, rate, rcRate, rcExpo, superExpoActive, deadband, limit) {
    let angleRate;

    if (rate !== undefined && rcRate !== undefined && rcExpo !== undefined) {
        let rcCommandf = this.rcCommand(rcData, 1, deadband);
        if (semver.gte(FC.CONFIG.apiVersion, API_VERSION_1_43)) {
            rcCommandf = rcCommandf / (500 - deadband);
        } else {
            rcCommandf = rcCommandf / 500;
        }

        const rcCommandfAbs = Math.abs(rcCommandf);

        switch(TABS.pid_tuning.currentRatesType) {
            case TABS.pid_tuning.RATES_TYPE.RACEFLIGHT:
                angleRate=this.getRaceflightRates(rcCommandf, rate, rcRate, rcExpo);

                break;

            case TABS.pid_tuning.RATES_TYPE.KISS:
                angleRate=this.getKISSRates(rcCommandf, rcCommandfAbs, rate, rcRate, rcExpo);

                break;

            case TABS.pid_tuning.RATES_TYPE.ACTUAL:
                angleRate=this.getActualRates(rcCommandf, rcCommandfAbs, rate, rcRate, rcExpo);

                break;

            case TABS.pid_tuning.RATES_TYPE.QUICKRATES:
                angleRate=this.getQuickRates(rcCommandf, rcCommandfAbs, rate, rcRate, rcExpo);

                break;

            // add future rates types here
            default: // BetaFlight
                angleRate=this.getBetaflightRates(rcCommandf, rcCommandfAbs, rate, rcRate, rcExpo, superExpoActive, limit);

                break;
        }
    }

    return angleRate;
};

RateCurve.prototype.getMaxAngularVel = function (rate, rcRate, rcExpo, superExpoActive, deadband, limit) {
    let maxAngularVel;
    if (!this.useLegacyCurve) {
        maxAngularVel = this.rcCommandRawToDegreesPerSecond(maxRc, rate, rcRate, rcExpo, superExpoActive, deadband, limit);
    }

    return maxAngularVel;
};

RateCurve.prototype.setMaxAngularVel = function (value) {
    this.maxAngularVel = Math.ceil(value/200) * 200;
    return this.maxAngularVel;

};

RateCurve.prototype.draw = function (rate, rcRate, rcExpo, superExpoActive, deadband, limit, maxAngularVel, context) {
    if (rate !== undefined && rcRate !== undefined && rcExpo !== undefined) {
        const height = context.canvas.height;
        const width = context.canvas.width;

        if (this.useLegacyCurve) {
            this.drawLegacyRateCurve(rate, rcRate, rcExpo, context, width, height);
        } else {
            this.drawRateCurve(rate, rcRate, rcExpo, superExpoActive, deadband, limit, maxAngularVel, context, width, height);
        }
    }
};