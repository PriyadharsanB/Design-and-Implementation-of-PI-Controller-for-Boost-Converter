# Design-and-Implementation-of-Analog-PI-Controlled-Boost-Converter


Design, modelling and simulation of a DC-DC boost converter progressively upgraded from open-loop operation to full closed-loop regulation with an analog PI controller — built and validated in LTspice. The design flow was entirely **ANALOG** and matlab was used for frequency analysis purposes analysis only.

By Priyadharsan
--
under the Guidance of Dr.Krishnaveni.S (Associate Professor), SSN-SNU Chennai
--
A student internship project, May-June 2026 (SSN College of Engineering, Chennai)

---

## Abstract

The project designs a boost converter that steps 12 V up to a regulated 24 V, then studies its behavior across three progressively more sophisticated control configurations: open loop, closed loop with only an error amplifier, and closed loop with a full PI controller. A small-signal model was derived using state-space averaging to obtain the converter's control-to-output transfer function, and Bode analysis was used to assess stability at each stage before validating everything against LTspice transient simulations.

**Design specs:** Vin = 12 V, Vout = 24 V, fs = 20 kHz, CCM operation
**Calculated parameters:** D = 0.5, L = 60 µH, C = 651 µF, R = 1.92 Ω

## Boost Converter (Open-Loop Plant)

The converter itself consists of an inductor, MOSFET switch, diode, output capacitor and load resistor, operated in Continuous Conduction Mode (CCM) so the inductor current never falls to zero within a switching cycle. During the switch-ON interval, the inductor stores energy from the source while the diode stays reverse-biased and the output capacitor supplies the load; during switch-OFF, the inductor releases its stored energy through the now forward-biased diode, boosting the output above the input.

The small-signal control-to-output transfer function Gvd(s) was derived via state-space averaging, using the inductor current and capacitor voltage as state variables and linearizing around the steady-state duty ratio. Bode analysis of this uncompensated plant gave a **Gain Margin of -33.6 dB** and a **Phase Margin of -77.4°** — both negative, meaning the plant is inherently unstable and cannot be used without compensation. This result is what motivates every closed-loop stage that follows.

## Open-Loop Operation

The converter was run with a fixed 50% duty cycle and no feedback of any kind, purely to characterize the plant's natural response.

- **Steady-state voltage:** 26.16 V (target was 24 V)
- **Peak overshoot:** 37.47 V
- **Rise time:** 0.429 ms, peak reached at 1.509 ms
- **Settling time:** 9.94 ms
- **Ripple:** ~0.6 V

Without any corrective mechanism, the converter boosts voltage but has no way to correct for the mismatch between the fixed duty cycle and the actual required operating point — it settles wherever the open-loop dynamics take it, well above the 24 V target, with a large startup overshoot.

## Closed Loop Without PI (Error Amplifier Only)

A resistive divider (1:10 ratio) senses the output voltage and feeds it back to a unity-gain error amplifier, which compares it against the reference and drives the PWM generator directly — proportional correction only, no integral term.

- **Steady-state voltage:** 23.24 V
- **Peak overshoot:** 27.92 V
- **Rise time:** 1.378 ms, peak reached at 2.111 ms
- **Settling time:** 14.132 ms
- **Ripple:** ~0.488 V

Feedback substantially improves things — overshoot drops by nearly 10 V and the steady-state voltage lands much closer to target. But because correction is purely proportional, a **steady-state error persists**: the loop only responds to an existing error, it never accumulates and cancels it out, so the output settles slightly below 24 V and stays there.

## Closed Loop With PI Controller

A PI controller (built from op-amps as a proportional stage, an integral stage, and a summing amplifier that recombines them) is inserted between the error amplifier and the PWM generator.

- **Steady-state voltage:** 24.00 V — **zero steady-state error**
- **Peak overshoot:** 25.686 V
- **Rise time:** 0.598 ms, peak reached at 0.77 ms
- **Settling time:** 19.40 ms
- **Ripple:** ~0.504 V (close to the 0.48 V design target)

The proportional term keeps the response fast, while the integral term continuously accumulates and drives out any residual error — which is exactly why the steady-state voltage lands exactly on 24 V. The trade-off is settling time: the integral action keeps making small corrections even after the output looks converged, so the system takes longer to fully settle within tolerance than the error-amplifier-only case, even though it gets there more accurately and with a smaller overshoot.

Closed-loop and loop-gain Bode analysis at this stage showed a **Phase Margin of -85.5°** (further degraded from open loop) because the PI controller's integral action adds an additional pole at the origin, introducing extra phase lag. Despite the negative phase margin on paper, the time-domain simulation shows accurate, stable regulation — a reminder that frequency-domain margins and transient practical performance both need to be checked, and that this particular instability could be addressed with a lead compensator in future work.

## Results Comparison

| Metric | Open Loop | Closed Loop (No PI) | Closed Loop (PI) |
|---|---|---|---|
| Steady-State Voltage | 26.16 V | 23.24 V | **24.00 V** |
| Peak Overshoot | 37.47 V | 27.92 V | **25.686 V** |
| Rise Time | 0.429 ms | 1.378 ms | 0.598 ms |
| Peak Time | 1.509 ms | 2.111 ms | 0.77 ms |
| Settling Time | 9.94 ms | 14.132 ms | 19.40 ms |
| Output Ripple | ~0.6 V | ~0.488 V | ~0.504 V |

**Reasoning:** The open-loop converter has the fastest rise time simply because nothing is holding it back — but with no feedback, it can't regulate to the correct voltage and overshoots badly. Adding the error amplifier introduces feedback that pulls both the overshoot and steady-state voltage much closer to target, but proportional-only correction leaves a persistent steady-state error since the loop only acts on error that already exists. The PI controller's integral term eliminates that steady-state error entirely and further reduces overshoot, at the cost of a longer settling time — a direct and expected consequence of the integral action continuing to fine-tune the output even after the response visually converges. Across all three metrics that matter most for a regulated supply — accuracy, overshoot, and stability — the PI-controlled configuration is the clear best performer, which is exactly the trade-off a PI controller is designed to make.

## Tools and Software

- LTspice (entire circuit design simulation and validation)
- MATLAB (Simulation and observation of derived small signal behavior in frequency domain)

---
