#if !defined(PSK_REPORTER_H)
#define PSK_REPORTER_H

//=========================================================================
// Name:            pskreporter.h
// Purpose:         Implementation of PSK Reporter support.
//
// Authors:         Mooneer Salem
// License:
//
//  All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.1,
//  as published by the Free Software Foundation.  This program is
//  distributed in the hope that it will be useful, but WITHOUT ANY
//  WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
//  License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, see <http://www.gnu.org/licenses/>.
//
//=========================================================================

#include <mutex>
#include "IReporter.h"

struct SenderRecord
{
    std::string callsign;
    uint64_t frequency;
    char snr;
    std::string mode;
    char infoSource;
    int flowTimeSeconds;
    
    SenderRecord(std::string callsign, uint64_t frequency, char snr);
    
    int recordSize();    
    void encode(char* buf);
};

class PskReporter : public IReporter
{
public:
    PskReporter(std::string callsign, std::string gridSquare, std::string software);
    virtual ~PskReporter();
    
    virtual void addReceiveRecord(std::string callsign, uint64_t frequency, char snr);
    virtual void send();

private:
    unsigned int currentSequenceNumber_;
    unsigned int randomIdentifier_;
    
    std::string receiverCallsign_;
    std::string receiverGridSquare_;
    std::string decodingSoftware_;
    std::vector<SenderRecord> recordList_;
    std::mutex recordListMutex_;
    
    int getRxDataSize_();    
    int getTxDataSize_();    
    void encodeReceiverRecord_(char* buf);    
    void encodeSenderRecords_(char* buf);
    
    bool reportCommon_();
};


#endif // PSK_REPORTER_H