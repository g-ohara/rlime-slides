\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{slide-en}[2024/05/21 Style for pdfTeX and Beamer (Genji Ohara)]

\RequirePackage{xkeyval}
\DeclareOptionX{aspectratio}[169]{\def\aspectratio{#1}}
\ProcessOptionsX{}
\LoadClass[aspectratio=\aspectratio,10pt]{beamer}

% -----------------------------------------------------------------------------
% Beamer Theme and Background Color
% -----------------------------------------------------------------------------

\usetheme[block=fill,numbering=fraction,sectionpage=none]{metropolis}
\setbeamercolor{background canvas}{bg=white}
\RequirePackage{appendixnumberbeamer}


% -----------------------------------------------------------------------------
% Font
% -----------------------------------------------------------------------------

% FiraFonts
\usepackage[sfdefault]{FiraSans}
\usepackage{FiraMono}

% Use thinner fonts
\makeatletter
\def\bfseries@sf{medium}
\def\mdseries@sf{l}
\makeatother

% Math font
\usefonttheme[onlymath]{serif}

% Caption font (make it smaller and disable reference number)
\RequirePackage[font=scriptsize,labelformat=empty]{caption}

% Footnote font (make it smaller)
\setbeamerfont{footnote}{size=\tiny}


% -----------------------------------------------------------------------------
% Title Page
% -----------------------------------------------------------------------------

% Prevent warning: "Overfull \vbox (15.63992pt too high) detected at line ..."
\let\oldmaketitle\maketitle
\renewcommand{\maketitle}{\vfuzz=15.63992pt\oldmaketitle}

% Automatically create title page
\AtBeginDocument{\maketitle}


% -----------------------------------------------------------------------------
% Section Page
% -----------------------------------------------------------------------------

% Style for section page
\setbeamertemplate{section page}{%
  \begingroup
  \begin{beamercolorbox}[sep=10pt,center,rounded=true,shadow=true]{section title}
    \usebeamerfont{section title}\insertsection\par
  \end{beamercolorbox}
  \endgroup
}


% -----------------------------------------------------------------------------
% Frame Title
% -----------------------------------------------------------------------------

% Set section, subsection and subsubsection as frame title
\newcommand\mysubsectiontitle{%
  \ifx\insertsubsection\empty\else~/~\insertsubsection\fi
}
\newcommand\mysubsubsectiontitle{%
  \ifx\insertsubsubsection\empty\else~/~\insertsubsubsection\fi
}
\let\oldframetitle\frametitle{}
\renewcommand{\frametitle}{
  \oldframetitle{\insertsection\mysubsectiontitle\mysubsubsectiontitle}
}


% -----------------------------------------------------------------------------
% Table of Contents
% -----------------------------------------------------------------------------

% Insert [short title] in ToC
\RequirePackage{etoolbox}
\makeatletter
\patchcmd{\beamer@section}{{#2}{\the\c@page}}{{#1}{\the\c@page}}{}{}
\patchcmd{\beamer@subsection}{{#2}{\the\c@page}}{{#1}{\the\c@page}}{}{}
\patchcmd{\beamer@subsubsection}{{#2}{\the\c@page}}{{#1}{\the\c@page}}{}{}
\makeatother


% -----------------------------------------------------------------------------
% Tables
% -----------------------------------------------------------------------------

\RequirePackage{booktabs}


% -----------------------------------------------------------------------------
% Bibliography
% -----------------------------------------------------------------------------

\usepackage[style=numeric, sorting=none, url=false, doi=false]{biblatex}

% Avoid giving different numbers to the same citations in different slides.
\DeclareCiteCommand{\footcite}{\usebibmacro{prenote}}{\footnotemark[\thefield{labelnumber}]\footnotetext[\thefield{labelnumber}]{\fullcite{\thefield{entrykey}}}}{\multicitedelim}{\usebibmacro{postnote}}

% Font size of bibliography
\def\bibsize{\tiny}
\setbeamerfont{bibliography entry author}{size=\bibsize}
\setbeamerfont{bibliography entry title}{size=\bibsize}
\setbeamerfont{bibliography entry note}{size=\bibsize}


% -----------------------------------------------------------------------------
% DateTime
% -----------------------------------------------------------------------------

% For \DTMdisplaydate
\usepackage[useregional]{datetime2}


% -----------------------------------------------------------------------------
% TikZ
% -----------------------------------------------------------------------------

\RequirePackage{tikz}
\usetikzlibrary{shapes.callouts,tikzmark,calc}

% Usage: \COLabel{name#1}{text#2}
% e.g.:  \COLabel{psi1}{$\psi_1$}
\newcommand{\COLabel}[2]{%
  \tikz[%
    remember picture,%
    baseline = (#1.base),%
    every node/.style={inner sep=0,outer sep=0}%
  ]{%
    \node(#1){#2};%
  }
}

% Usage: \CO<page#1>{target name#2}{++(x,y)#3}[opt#4]{text#5}
% e.g.:  \CO<2>{psi1}{++(-4,1.5)}[text width=3cm]{hogehoge fugafuga piyopiyo}
\NewDocumentCommand\CO{d<> m m O{} m}{%
  \begin{tikzpicture}[
      remember picture,
      overlay,
      every text node part/.style={align=center}
    ]
    \IfValueTF{#1}{\path<#1>}{\path} (#2.center) #3 node[%
      anchor=center,%
      rectangle callout,%
      fill=blue!20,%
      callout absolute pointer={(#2.mid)},%
      font=\bfseries\footnotesize,
      rounded corners,
      #4
    ]{#5};
  \end{tikzpicture}
}
\newcommand{\colorrect}[2]
{%
  \tikz[baseline = (x.base),
    every text node part/.style={align=center}
  ]{%
    \node(x)[rectangle, fill=#1, rounded corners]{#2}
  }
}
