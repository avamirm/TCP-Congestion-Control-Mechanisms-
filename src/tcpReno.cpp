#include "tcpReno.hpp"

float TCPReno::lostProb(int num, int start, int end)
{
    return (pow(10 * end, static_cast<float>(num - start) / (end - start)) - 1) / (10 * end - 1);
}

bool TCPReno::isPacketLost()
{
    int prob = static_cast<int>(advwnd * lostProb(_cwnd, 1, advwnd));
    bool isPacketLost = (rand() % advwnd + 1) > prob;
    return isPacketLost;
}

void TCPReno::sendData()
{
    if (timeout != 0)
        return;

    dupAckCount = 0;
    packetLost = false;
    int lastAck = sw.lastAck;
    for (int i = lastAck; i < lastAck + _cwnd && i < static_cast<int>(packets.size()); i++)
    {
        if (isPacketLost())
        {
            if (packetLost)
                dupAckCount++;
            else
                sw.lastAck++;
        }
        else
            packetLost = true;
    }
}

bool TCPReno::onePacketLoss()
{
    if (timeout != 0)
    {
        timeout--;
        return true;
    }

    if (dupAckCount >= 3)
    {
        mode = FAST_RETRANSMIT;
        _cwnd = _cwnd / 2;
        _ssthresh = _cwnd;
        return true;
    }
    if (packetLost)
    {
        mode = SLOW_START;
        timeout = TIMEOUT;
        // timeout += 1;
        _ssthresh = _cwnd / 2;
        _cwnd = 1;
        return true;
    }
    return false;
}

void TCPReno::oneRTTUpdate()
{
    if (mode == SLOW_START)
    {
        if (_cwnd < _ssthresh)
            _cwnd *= 2;
        else if (_cwnd == _ssthresh)
            mode = CONGESTION_AVOIDANCE;
        else if (2 * _cwnd > _ssthresh)
            _cwnd = _ssthresh;
    }
    else if (mode == CONGESTION_AVOIDANCE)
    {
        _cwnd++;
    }
    else if (mode == FAST_RETRANSMIT)
    {
        mode = CONGESTION_AVOIDANCE;
    }
}