function EEG = FTfreqanalysis(EEG,select,freqrange,intimes,basetimewin,ncycles)

if ~exist('select','var')
    error('update calling function to include select')
end

cfg = [];
if strcmp(select,'Freq')
    cfg.output     = 'pow';
    cfg.method     = 'mtmfft';
    
elseif strcmp(select,'TF')
    cfg.output     = 'pow';
    cfg.method     = 'mtmconvol';
    
    % ALTERNATIVE: wavelets
    %cfg.t_ftimwin    = ncycles./cfg.foi;  % cycles per time window (wavelets only)
    %cfg.method     = 'wavelet';                
    %cfg.width      = ncycles;  
    
elseif strcmp(select,'Coh')
    cfg.output     = 'powandcsd';
    cfg.method     = 'mtmfft';
end
%timewin = length(intimes)/(intimes(2)-intimes(1))/1000;
cfg.pad        = min(divisors(min(freqrange)));%-timewin;%'nextpow2';
if size(freqrange,1)>1
    cfg.foilim        = [min(freqrange) max(freqrange)];
else
    cfg.foi     = freqrange;
end

if any(freqrange<30)
    cfg.taper       = 'Hanning';
else
    cfg.taper       = 'dpss';
    cfg.tapsmofrq    = 5;
end
cfg.toi          = intimes;

cfg.keeptrials = 'yes';
%cfg.precision = 'single';
EEG = ft_freqanalysis(cfg,EEG); 
