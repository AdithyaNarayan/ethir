import React, { useState } from 'react';
import Layout from '@theme/Layout';

export default function Simulator() {
  let [alpha, setAlpha] = useState(50); // %
  let [collateral, setCollateral] = useState(1); // ETH
  let [rewards, setRewards] = useState(1); // ETH
  let [apy, setApy] = useState(6); // %
  let [timeToExpiry, setTimeToExpiry] = useState(7); // days

  const getMintRewards = () => {
    return (alpha / 100) * rewards;
  };

  const getBurnRewards = () => {
    return (100 - alpha) / 100 * rewards;
  };

  const getMintRewardsAfterInterest = () => {
    return getMintRewards() * (1 + (apy / 100) * (timeToExpiry / 365));
  };

  const getExpiryGasCost = () => {
    return collateral + getBurnRewards() + getMintRewardsAfterInterest() - getMintRewards();
  };

  return (
    <Layout title="Hello" description="Hello React Page">
      <div style={{
        display: 'flex', flexDirection: 'row',
        fontSize: '20px',
      }}>
        <div
          style={{
            display: 'flex',
            padding: '50px',
            flexDirection: 'column',
          }}>
          <div style={{
            display: 'flex',
          }}>

            <p style={{ paddingRight: '10px' }}>Collateral (in ETH): </p>
            <input type="number" style={{
              width: '125px',
              height: '30px',
              fontSize: '18px',
            }} onChange={e => setCollateral(Number(e.target.value))} />
          </div>

          <div style={{
            display: 'flex',
          }}>

            <p style={{ paddingRight: '10px' }}>Rewards/Market value of gas futures (in ETH): </p>
            <input type="number" style={{
              width: '125px',
              height: '30px',
              fontSize: '18px',
            }} onChange={e => setRewards(Number(e.target.value))} />

          </div>
          <div style={{ display: 'flex', }}>
            <p>
              <div style={{ display: 'flex', flexDirection: 'column' }}>
                <p>Mint Rewards</p>
                <p>{getMintRewards()} ETH</p>
              </div>
            </p>
            <p style={{ paddingLeft: '30px' }}>
              <div style={{ display: 'flex', flexDirection: 'column' }}>
                <p>Burn Rewards</p>
                <p>{getBurnRewards()} ETH</p>
              </div>
            </p>
          </div>
          <input type="range"
            style={{
              accentColor: 'green',
              width: '250px',
            }}
            min="0" max="100" onChange={e => setAlpha(Number(e.target.value))} />

          <p>Alpha = {alpha}%</p>
        </div>
        <div>
          <div style={{
            display: 'flex',
            paddingTop: '50px'
          }}>
            <p style={{ paddingRight: '10px' }}>APY/Interest Rate (in %): </p>
            <input type="number" style={{
              width: '125px',
              height: '30px',
              fontSize: '18px',
            }} onChange={e => setApy(Number(e.target.value))} />
          </div>
          <div style={{
            display: 'flex',
          }}>
            <p style={{ paddingRight: '10px' }}>Time to expiry (in days):</p>
            <input type="number" style={{
              width: '125px',
              height: '30px',
              fontSize: '18px',
            }} onChange={e => setTimeToExpiry(Number(e.target.value))} />
          </div>
        </div>
      </div>
      <div style={{ padding: '20px', fontSize: '24px' }}>
        <p>Value of Mint Rewards on expiry: <b>{getMintRewardsAfterInterest()}</b>{" "}ETH</p>
        <p>Maximum permissable gas cost on day of expiry: <b>{getExpiryGasCost()}</b>{" "}ETH</p>

      </div>
    </Layout>
  );
}
